# frozen_string_literal: true
# Adapted from oxtech-ember/Ember-Agent-Skills; see LICENSE.

require 'json'
require 'yaml'
require 'open3'
require 'tmpdir'
require 'timeout'
require_relative 'skill-writing'

ROOT = File.expand_path('..', __dir__)

def check(condition, message)
  abort "FAIL: #{message}" unless condition
end

def read_json(path)
  JSON.parse(File.read(path))
end

def inside_package?(path)
  File.exist?(path) && File.realpath(path).start_with?(File.realpath(ROOT) + '/')
end

def check_icon(interface, field, root)
  path = interface[field]
  check(path == './assets/emberbsd-logo.png', "#{field} must point at the bundled EmberBSD icon")
  target = File.join(root, path)
  check(File.file?(target) && File.realpath(target).start_with?(File.realpath(root) + '/assets/'),
        "missing or external icon: #{target}")
  check(File.binread(target) == File.binread(File.join(ROOT, 'assets/emberbsd-logo.png')),
        "icon differs from the package's EmberBSD logo: #{target}")
end

def codex_response(input, output, id, method, params)
  input.puts(JSON.generate(id: id, method: method, params: params))
  loop do
    response = JSON.parse(output.readline)
    next unless response['id'] == id

    raise "Codex #{method} failed: #{response['error']}" if response['error']

    return response.fetch('result')
  end
end

def codex_plugin_detail(profile_dir, plugin_name)
  Open3.popen3({ 'CODEX_HOME' => profile_dir, 'RUST_LOG' => 'warn' }, 'codex', 'app-server',
              '--stdio', '-c', 'features.plugins=true', '-c', 'features.remote_plugin=false',
              chdir: ROOT) do |input, output, errors, process|
    errors_reader = Thread.new { errors.read }
    begin
      Timeout.timeout(20) do
        codex_response(input, output, 1, 'initialize', {
          clientInfo: { name: 'ember-package-check', version: '1' },
          capabilities: { experimentalApi: true }
        })
        input.puts(JSON.generate(method: 'initialized', params: {}))
        codex_response(input, output, 2, 'plugin/read', {
          marketplacePath: File.join(ROOT, '.agents/plugins/marketplace.json'),
          pluginName: plugin_name
        }).fetch('plugin')
      end
    ensure
      input.close
      unless process.join(5)
        Process.kill('TERM', process.pid)
        Process.kill('KILL', process.pid) unless process.join(5)
      end
      process.value
      errors_reader.value
    end
  end
end

def codex_plugin_list(profile_dir, catalog_name, config)
  Open3.popen3({ 'CODEX_HOME' => profile_dir }, 'codex', 'plugin', 'list',
              '--marketplace', catalog_name, '--available', '--json', '-c', config,
              chdir: ROOT) do |input, output, errors, process|
    input.close
    readers = [output, errors].map { |stream| Thread.new { stream.read } }
    begin
      Timeout.timeout(20) { [readers[0].value, readers[1].value, process.value] }
    ensure
      unless process.join(5)
        Process.kill('TERM', process.pid)
        Process.kill('KILL', process.pid) unless process.join(5)
      end
      readers.each(&:kill)
    end
  end
end

check(ARGV.empty? || ARGV == ['--codex'], 'usage: ruby scripts/check-package.rb [--codex]')

begin
  manifest = read_json(File.join(ROOT, 'plugin.json'))
  catalog = read_json(File.join(ROOT, '.agents/plugins/marketplace.json'))
  check(manifest['$schema'] == 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json',
        'portable manifest schema is missing or changed; review compatibility')
  check(manifest['name'] == 'emberbsd-user', 'unexpected plugin identity')
  check(manifest['version'].is_a?(String) && manifest['version'].match?(/\A\d+\.\d+\.\d+\z/),
        'set a release version in plugin.json')
  check(manifest['license'] == 'MIT' && File.file?(File.join(ROOT, 'LICENSE')), 'MIT license missing')
  check(catalog['name'] == 'emberbsd-user-skills', 'unexpected marketplace identity')
  check(catalog['plugins'].is_a?(Array) && catalog['plugins'].length == 1, 'expected one plugin')
  entry = catalog['plugins'].first
  check(entry['name'] == manifest['name'], 'marketplace and plugin names disagree')
  check(entry['source'] == { 'source' => 'local', 'path' => './' }, 'plugin must resolve to repository root')
  check(entry['policy'] == { 'installation' => 'AVAILABLE', 'authentication' => 'ON_INSTALL' },
        'review marketplace installation and authentication policies')
  check(entry['category'] == manifest.dig('extensions', 'com.openai', 'interface', 'category'),
        'marketplace and plugin categories disagree')
  plugin_interface = manifest.fetch('extensions').fetch('com.openai').fetch('interface')
  %w[composerIcon logo].each { |field| check_icon(plugin_interface, field, ROOT) }

  client_manifest = read_json(File.join(ROOT, '.claude-plugin/plugin.json'))
  client_catalog = read_json(File.join(ROOT, '.claude-plugin/marketplace.json'))
  check(client_manifest['name'] == manifest['name'], 'client manifest identity disagrees')
  check(client_manifest['version'] == manifest['version'], 'client manifest version disagrees')
  check(client_manifest['skills'] == './skills' && File.directory?(File.join(ROOT, 'skills')),
        'client manifest must expose the bundled skills directory')
  check(client_catalog['name'] == catalog['name'], 'client catalog identity disagrees')
  check(client_catalog.dig('metadata', 'version') == manifest['version'], 'client catalog version disagrees')
  client_entry = client_catalog['plugins'].is_a?(Array) ? client_catalog['plugins'].first : nil
  check(client_entry && client_entry['name'] == manifest['name'], 'client catalog plugin identity disagrees')
  check(client_entry['source'] == './', 'client catalog plugin must resolve to repository root')
  check(client_entry['version'] == manifest['version'], 'client catalog plugin version disagrees')
  check(client_entry['icon'] == 'https://raw.githubusercontent.com/oxtech-ember/EmberBSD-User-Skills/main/assets/emberbsd-logo.png' &&
        File.file?(File.join(ROOT, 'assets/emberbsd-logo.png')),
        'client catalog icon must point at the bundled asset')

  kimi_manifest = read_json(File.join(ROOT, 'kimi.plugin.json'))
  check(kimi_manifest['name'] == manifest['name'], 'kimi manifest identity disagrees')
  check(kimi_manifest['version'] == manifest['version'], 'kimi manifest version disagrees')
  check(kimi_manifest['name'].match?(/\A[a-z0-9][a-z0-9_-]{0,63}\z/), 'kimi manifest name is not a valid plugin id')
  check(kimi_manifest['description'] == manifest['description'], 'kimi manifest description disagrees')
  check(kimi_manifest['license'] == 'MIT', 'kimi manifest license disagrees')
  check(kimi_manifest['skills'] == './skills/', 'kimi manifest must expose the bundled skills directory')
  kimi_interface = kimi_manifest.fetch('interface')
  check(kimi_interface['displayName'] == plugin_interface['displayName'], 'kimi display name disagrees')
  check(kimi_interface['shortDescription'] == plugin_interface['shortDescription'], 'kimi short description disagrees')
  check(kimi_interface['longDescription'] == plugin_interface['longDescription'], 'kimi long description disagrees')
  check(kimi_interface['developerName'] == plugin_interface['developerName'], 'kimi developer name disagrees')
  check(kimi_interface['websiteURL'] == plugin_interface['websiteURL'], 'kimi website URL disagrees')

  skill_directories = Dir.glob(File.join(ROOT, 'skills', '*')).select { |path| File.directory?(path) }.sort
  check(!skill_directories.empty?, 'no skills found')
  skills = skill_directories.map do |directory|
    path = File.join(directory, 'SKILL.md')
    check(File.file?(path), "missing skill entry point: #{directory}")
    path
  end
  writing_errors = []
  skills.each do |path|
    check(inside_package?(path), "skill escapes package: #{path}")
    content = File.read(path)
    header = content.match(/\A---\r?\n(.*?)\r?\n---(?:\r?\n|\z)/m)
    check(header, "missing frontmatter: #{path}")
    metadata = YAML.safe_load(header[1])
    name = File.basename(File.dirname(path))
    check(metadata.is_a?(Hash) && metadata['name'] == name, "skill name must match directory: #{name}")
    check(name.match?(/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/) && name.length <= 64, "invalid skill name: #{name}")
    description = metadata['description']
    check(description.is_a?(String) && (1..1024).cover?(description.strip.length),
          "missing or oversized description: #{name}")
    writing_errors.concat(SkillWriting.errors(File.dirname(path), description))
    presentation = File.join(File.dirname(path), 'agents/openai.yaml')
    check(File.file?(presentation), "missing Codex skill presentation: #{name}")

    check(File.realpath(presentation).start_with?(File.realpath(File.dirname(path)) + '/'),
          "presentation escapes skill: #{name}")
    interface = YAML.safe_load(File.read(presentation)).fetch('interface')
    check(interface['display_name'].is_a?(String), "missing display name: #{name}")
    check((25..64).cover?(interface.fetch('short_description').length), "invalid short description: #{name}")
    check(interface.fetch('default_prompt').include?("$#{name}"), "default prompt must name skill: #{name}")
    %w[icon_small icon_large].each { |field| check_icon(interface, field, File.dirname(path)) }
  end
  check(writing_errors.empty?, writing_errors.join("\n"))

  puts "PASS: #{manifest['name']} #{manifest['version']}; #{skills.length} skill(s); local consistency"
  if ARGV == ['--codex']
    config = "marketplaces.#{catalog['name']}={source_type=\"local\",source=#{ROOT.to_json}}"
    # An installed older release can hide the candidate from the available list.
    # Keep discovery independent of the user's installed plugins and settings.
    output, errors, status = Dir.mktmpdir('ember-skills-codex-') do |profile_dir|
      codex_plugin_list(profile_dir, catalog['name'], config)
    end
    check(status.success?, "Codex discovery failed: #{errors}")
    result = JSON.parse(output)
    plugin_id = "#{manifest['name']}@#{catalog['name']}"
    discovered = (result.fetch('available', []) + result.fetch('installed', [])).find do |plugin|
      plugin['pluginId'] == plugin_id && plugin['version'] == manifest['version']
    end
    check(discovered, "Codex did not discover #{plugin_id} at version #{manifest['version']}")
    puts "PASS: native Codex discovery of #{plugin_id} #{manifest['version']}"
    detail = Dir.mktmpdir('ember-skills-codex-icons-') do |profile_dir|
      codex_plugin_detail(profile_dir, manifest.fetch('name'))
    end
    %w[composerIcon logo].each do |field|
      check(detail.fetch('summary').fetch('interface')[field] == File.join(ROOT, 'assets/emberbsd-logo.png'),
            "Codex did not resolve plugin #{field}")
    end
    skills.each do |path|
      name = File.basename(File.dirname(path))
      native_skill = detail.fetch('skills').find { |skill| skill['name'] == "#{manifest['name']}:#{name}" }
      check(native_skill, "Codex did not read skill: #{name}")
      %w[iconSmall iconLarge].each do |field|
        check(native_skill.fetch('interface')[field] == File.join(File.dirname(path), 'assets/emberbsd-logo.png'),
              "Codex did not resolve #{name} #{field}")
      end
    end
    puts "PASS: native Codex plugin and skill icon paths"
  end
rescue JSON::ParserError, Psych::Exception, KeyError, TypeError, NoMethodError, SystemCallError,
       EOFError, Timeout::Error, RuntimeError => error
  abort "FAIL: #{error.message}"
end
