# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'yaml'

class PackageCheckTest
  SOURCE = File.expand_path('..', __dir__)
  SHORT_BODY = "# Fixture\n\nInspect the target.\n"

  def assert(condition, message)
    raise message unless condition
  end

  def refute(condition, message)
    assert(!condition, message)
  end

  def assert_match(pattern, text)
    assert(pattern.match?(text), "expected #{pattern.inspect} in #{text.inspect}")
  end

  def with_package
    Dir.mktmpdir('ember-package-test-') do |root|
      %w[plugin.json LICENSE assets/emberbsd-logo.png .agents/plugins/marketplace.json
         .claude-plugin/plugin.json .claude-plugin/marketplace.json].each do |relative|
        target = File.join(root, relative)
        FileUtils.mkdir_p(File.dirname(target))
        FileUtils.cp(File.join(SOURCE, relative), target)
      end
      FileUtils.cp_r(File.join(SOURCE, 'scripts'), root)
      name = 'fixture-skill'
      skill = File.join(root, 'skills', name)
      FileUtils.mkdir_p(File.join(skill, 'agents'))
      FileUtils.mkdir_p(File.join(skill, 'assets'))
      interface = {
        'display_name' => 'Fixture skill',
        'short_description' => 'Inspect a selected target with concise steps',
        'icon_small' => './assets/emberbsd-logo.png',
        'icon_large' => './assets/emberbsd-logo.png',
        'default_prompt' => 'Use $fixture-skill to inspect the selected target.'
      }
      File.write(File.join(skill, 'agents/openai.yaml'), { 'interface' => interface }.to_yaml)
      FileUtils.cp(File.join(SOURCE, 'assets/emberbsd-logo.png'),
                   File.join(skill, 'assets/emberbsd-logo.png'))
      write_skill(skill, name: name)
      yield root, skill
    end
  end

  def write_skill(skill, name: File.basename(skill), description: 'Use when inspecting a target.',
                  body: SHORT_BODY)
    header = { 'name' => name, 'description' => description }.to_yaml
    File.write(File.join(skill, 'SKILL.md'), "#{header}---\n\n#{body}")
  end

  def check_package(root)
    output, errors, status = Open3.capture3(RbConfig.ruby, 'scripts/check-package.rb', chdir: root)
    [status.success?, output + errors]
  end

  def assert_rejected(root, message)
    success, output = check_package(root)
    refute success, "checker accepted an invalid package: #{output}"
    assert_match message, output
  end

  def test_small_standalone_package_passes
    with_package do |root, _skill|
      success, output = check_package(root)
      assert success, output
      assert_match(/1 skill\(s\)/, output)
    end
  end

  def test_description_over_25_words_is_rejected
    with_package do |root, skill|
      write_skill(skill, description: Array.new(26, 'target').join(' '))
      assert_rejected(root, /description exceeds 25 words/)
    end
  end

  def test_entry_over_250_words_is_rejected
    with_package do |root, skill|
      write_skill(skill, body: "# Fixture\n\n" + "Inspect the target.\n\n" * 84)
      assert_rejected(root, /SKILL\.md exceeds 250 prose words/)
    end
  end

  def test_reference_over_500_words_is_rejected
    with_package do |root, skill|
      FileUtils.mkdir_p(File.join(skill, 'references'))
      File.write(File.join(skill, 'references', 'large.md'), "Inspect the target.\n\n" * 167)
      assert_rejected(root, /large\.md exceeds 500 prose words/)
    end
  end

  def test_multiline_sentence_over_20_words_is_rejected
    with_package do |root, skill|
      half = Array.new(10, 'target').join(' ')
      write_skill(skill, body: "Inspect #{half}\n#{half}.\n")
      assert_rejected(root, /sentence exceeds 20 words/)
    end
  end

  def test_list_item_without_punctuation_is_checked
    with_package do |root, skill|
      write_skill(skill, body: "- Inspect #{Array.new(20, 'target').join(' ')}\n")
      assert_rejected(root, /sentence exceeds 20 words/)
    end
  end

  def test_table_prose_is_checked
    with_package do |root, skill|
      sentence = "Inspect #{Array.new(20, 'target').join(' ')}."
      write_skill(skill, body: "| Task | Action |\n| --- | --- |\n| Target | #{sentence} |\n")
      assert_rejected(root, /sentence exceeds 20 words/)
    end
  end

  def test_headings_and_table_labels_count_toward_prose_total
    with_package do |root, skill|
      body = "# #{Array.new(130, 'label').join(' ')}\n\n| #{Array.new(121, 'label').join(' ')} |\n| --- |\n"
      write_skill(skill, body: body)
      assert_rejected(root, /SKILL\.md exceeds 250 prose words/)
    end
  end

  def test_fenced_commands_are_excluded
    with_package do |root, skill|
      body = SHORT_BODY + "\n```sh\n#{Array.new(600, 'literal').join(' ')}\n[example](missing.md)\n```\n"
      write_skill(skill, body: body)
      success, output = check_package(root)
      assert success, output
    end
  end

  def test_inline_commands_and_link_destinations_are_not_sentences
    with_package do |root, skill|
      body = "Run `./tool --literal #{Array.new(30, 'argument').join(' ')}`.\n"
      body += "Read [the guide](references/guide.md#first-step).\n"
      write_skill(skill, body: body)
      FileUtils.mkdir_p(File.join(skill, 'references'))
      File.write(File.join(skill, 'references/guide.md'), "# First step\n\nInspect the target.\n")
      success, output = check_package(root)
      assert success, output
    end
  end

  def test_sibling_skill_reference_is_rejected
    with_package do |root, skill|
      sibling = File.join(root, 'skills/other')
      FileUtils.cp_r(skill, sibling)
      write_skill(sibling)
      presentation = File.join(sibling, 'agents/openai.yaml')
      File.write(presentation, File.read(presentation).gsub("$#{File.basename(skill)}", '$other'))
      write_skill(skill, body: "Read [the guide](../other/SKILL.md).\n")
      assert_rejected(root, /reference escapes skill/)
    end
  end

  def test_skill_directory_without_entry_is_rejected
    with_package do |root, _skill|
      FileUtils.mkdir_p(File.join(root, 'skills/other'))
      assert_rejected(root, /missing skill entry point/)
    end
  end

  def test_markdown_extension_has_deep_links_checked
    with_package do |root, skill|
      FileUtils.mkdir_p(File.join(skill, 'references'))
      File.write(File.join(skill, 'references/guide.markdown'), "Read [the guide](missing.md).\n")
      assert_rejected(root, /missing bundled reference/)
    end
  end

  def test_symlink_reference_outside_skill_is_rejected
    with_package do |root, skill|
      File.symlink(File.join(root, 'LICENSE'), File.join(skill, 'guide.md'))
      write_skill(skill, body: "Read [the guide](guide.md).\n")
      assert_rejected(root, /(?:reference|markdown) escapes skill/)
    end
  end

  def test_missing_skill_icon_is_rejected
    with_package do |root, skill|
      FileUtils.rm(File.join(skill, 'assets/emberbsd-logo.png'))
      assert_rejected(root, /missing or external icon/)
    end
  end

  def test_missing_skill_presentation_is_rejected
    with_package do |root, skill|
      FileUtils.rm(File.join(skill, 'agents/openai.yaml'))
      assert_rejected(root, /missing Codex skill presentation/)
    end
  end

  def test_unlinked_deep_markdown_has_its_references_checked
    with_package do |root, skill|
      FileUtils.mkdir_p(File.join(skill, 'references/deep'))
      File.write(File.join(skill, 'references/deep/guide.md'), "Read [the missing guide](missing.md#step).\n")
      assert_rejected(root, /missing bundled reference/)
    end
  end

  def test_reference_style_link_is_checked
    with_package do |root, skill|
      write_skill(skill, body: "Read [the guide][manual].\n\n[manual]: missing.md\n")
      assert_rejected(root, /missing bundled reference/)
    end
  end

  def test_missing_local_fragment_is_rejected
    with_package do |root, skill|
      write_skill(skill, body: SHORT_BODY + "\nRead [the step](#missing-step).\n")
      assert_rejected(root, /missing markdown fragment/)
    end
  end

  def test_fragment_with_title_and_encoded_local_path_passes
    with_package do |root, skill|
      FileUtils.mkdir_p(File.join(skill, 'references'))
      File.write(File.join(skill, 'references/first guide.md'), "# First step\n\nInspect the target.\n")
      write_skill(skill, body: "Read [the guide](references/first%20guide.md#first-step \"Guide\").\n")
      success, output = check_package(root)
      assert success, output
    end
  end

  def test_duplicate_heading_fragment_preserves_technical_underscores
    with_package do |root, skill|
      body = "# Run `CLI_name`\n\n# Run `CLI_name`\n\nRead [the step](#run-cli_name-1).\n"
      write_skill(skill, body: body)
      success, output = check_package(root)
      assert success, output
    end
  end
end

failures = []
tests = PackageCheckTest.instance_methods(false).grep(/\Atest_/).sort
tests.each do |name|
  PackageCheckTest.new.public_send(name)
rescue StandardError => error
  failures << "#{name}: #{error.message}"
end
warn failures.join("\n") unless failures.empty?
puts "#{tests.length} tests; #{failures.length} failures"
exit(failures.empty? ? 0 : 1)
