# frozen_string_literal: true
# Adapted from oxtech-ember/Ember-Agent-Skills; see LICENSE.

require 'json'
require 'yaml'
require 'open3'
require 'tmpdir'

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

  skills = Dir.glob(File.join(ROOT, 'skills', '*', 'SKILL.md'))
  check(!skills.empty?, 'no skills found')
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
    content.scan(/\]\(([^)]+)\)/).flatten.each do |reference|
      next if reference.match?(/\A(?:https?:|#)/)
      target = File.expand_path(reference.split('#', 2).first, File.dirname(path))
      check(inside_package?(target), "missing or external bundled reference: #{reference}")
    end
    presentation = File.join(File.dirname(path), 'agents/openai.yaml')
    next unless File.file?(presentation)

    check(inside_package?(presentation), "presentation escapes package: #{name}")
    interface = YAML.safe_load(File.read(presentation)).fetch('interface')
    check(interface['display_name'].is_a?(String), "missing display name: #{name}")
    check((25..64).cover?(interface.fetch('short_description').length), "invalid short description: #{name}")
    check(interface.fetch('default_prompt').include?("$#{name}"), "default prompt must name skill: #{name}")
  end

  puts "PASS: #{manifest['name']} #{manifest['version']}; #{skills.length} skill(s); local consistency"
  if ARGV == ['--codex']
    config = "marketplaces.#{catalog['name']}={source_type=\"local\",source=#{ROOT.to_json}}"
    # An installed older release can hide the candidate from the available list.
    # Keep discovery independent of the user's installed plugins and settings.
    output, errors, status = Dir.mktmpdir('ember-skills-codex-') do |profile_dir|
      Open3.capture3({ 'CODEX_HOME' => profile_dir }, 'codex', 'plugin', 'list',
                    '--marketplace', catalog['name'], '--available', '--json',
                    '-c', config, chdir: ROOT)
    end
    check(status.success?, "Codex discovery failed: #{errors}")
    result = JSON.parse(output)
    plugin_id = "#{manifest['name']}@#{catalog['name']}"
    discovered = (result.fetch('available', []) + result.fetch('installed', [])).find do |plugin|
      plugin['pluginId'] == plugin_id && plugin['version'] == manifest['version']
    end
    check(discovered, "Codex did not discover #{plugin_id} at version #{manifest['version']}")
    puts "PASS: native Codex discovery of #{plugin_id} #{manifest['version']}"
  end
rescue JSON::ParserError, Psych::Exception, KeyError, TypeError, NoMethodError, SystemCallError => error
  abort "FAIL: #{error.message}"
end
