# frozen_string_literal: true

require 'uri'

# A bounded Markdown check, not an ASD-STE100 dictionary or grammar validator.
module SkillWriting
  DESCRIPTION_WORDS = 25
  ENTRY_WORDS = 250
  REFERENCE_WORDS = 500
  SENTENCE_WORDS = 20

  module_function

  def inside?(path, root)
    path == root || path.start_with?(root + File::SEPARATOR)
  end

  def literal_lines(content)
    lines = content.lines.map.with_index(1) { |line, number| [number, line.chomp] }
    if lines.first && lines.first[1] == '---'
      ending = lines.drop(1).index { |_number, line| line == '---' }
      lines.take(ending + 2).each { |entry| entry[1] = '' } if ending
    end
    fence = nil
    lines.each do |entry|
      line = entry[1]
      if fence
        fence = nil if line.match?(/\A {0,3}#{Regexp.escape(fence[0])}{#{fence[1]},}\s*\z/)
        entry[1] = ''
      elsif (match = line.match(/\A {0,3}(`{3,}|~{3,})[^\n]*\z/))
        fence = [match[1][0], match[1].length]
        entry[1] = ''
      end
    end
    lines
  end

  # Balance parentheses so URL parentheses and optional link titles remain intact.
  def inline_destinations(text)
    found = []
    position = 0
    while (start = text.index('](', position))
      cursor = start + 2
      depth = 1
      quote = nil
      angle = false
      while cursor < text.length
        character = text[cursor]
        if character == '\\'
          cursor += 2
          next
        end
        if quote
          quote = nil if character == quote
        elsif angle
          angle = false if character == '>'
        elsif character == '<'
          angle = true
        elsif %w[" '].include?(character) && text[cursor - 1].match?(/\s/)
          quote = character
        elsif character == '('
          depth += 1
        elsif character == ')'
          depth -= 1
          break if depth.zero?
        end
        cursor += 1
      end
      break unless depth.zero?

      found << [start + 1, cursor, destination(text[(start + 2)...cursor])]
      position = cursor + 1
    end
    found
  end

  def destination(text)
    value = text.strip
    target = value.start_with?('<') ? value[/\A<([^>]*)>/, 1] : value[/\A(?:\\.|[^\s])*/]
    (target || '').gsub(/\\([[:punct:]])/, '\\1')
  end

  def reference_definition(line)
    line.match(/\A {0,3}\[([^\]^]+)\]:\s*(.*)\z/)
  end

  def prose_text(text, literal: true)
    value = text.dup
    value.gsub!(/(`+)(.*?)\1/) { literal ? 'LITERAL' : Regexp.last_match(2) }
    inline_destinations(value).reverse_each { |start, ending, _target| value[start..ending] = '' }
    value.gsub!(/(!?\[[^\]]*\])\s*\[[^\]]*\]/, '\\1')
    value.gsub!(/<[^>]*>/, '')
    value.gsub!(/[\[\]*~]/, '')
    value.gsub!(/(?<![[:alnum:]])_+|_+(?![[:alnum:]])/, '')
    value.strip
  end

  def words(text)
    text.split.count { |word| word.match?(/[[:alnum:]]/) }
  end

  def table_cells(line)
    value = line.strip.sub(/\A\|/, '').sub(/(?<!\\)\|\z/, '')
    value.split(/(?<!\\)\|/, -1).map(&:strip)
  end

  def table_divider?(line)
    line.include?('|') && table_cells(line).all? { |cell| cell.match?(/\A:?-+:?\z/) }
  end

  # Keep list continuations together; wrapping lines cannot reset sentence limits.
  def units(lines)
    output = []
    paragraph = []
    first_line = nil
    flush = lambda do |kind = :prose|
      output << [first_line, kind, prose_text(paragraph.join(' '))] unless paragraph.empty?
      paragraph = []
      first_line = nil
    end
    in_table = false
    lines.each_with_index do |(number, original), index|
      line = original.sub(/\A\s*>\s?/, '')
      if line.strip.empty? || reference_definition(line)
        flush.call
        in_table = false
      elsif (heading = line.match(/\A {0,3}\#{1,6}\s+(.*?)\s*\#*\z/))
        flush.call
        output << [number, :heading, prose_text(heading[1])]
        in_table = false
      elsif line.match?(/\A {0,3}(?:=+|-+)\s*\z/) && !paragraph.empty?
        flush.call(:heading)
      elsif table_divider?(line)
        flush.call
        in_table = true
      elsif line.include?('|') && (in_table || line.strip.start_with?('|') ||
                                  table_divider?(lines.fetch(index + 1, [nil, ''])[1]))
        flush.call
        table_cells(prose_text(line)).each { |cell| output << [number, :table, cell] }
        in_table = true
      elsif (item = line.match(/\A\s*(?:[-+*]|\d+[.)])\s+(.*)\z/))
        flush.call
        paragraph << item[1]
        first_line = number
        in_table = false
      else
        paragraph << line.strip
        first_line ||= number
        in_table = false
      end
    end
    flush.call
    output
  end

  def anchors(content)
    lines = literal_lines(content)
    found = lines.map(&:last).join("\n").scan(/<[^>]+\b(?:id|name)=["']([^"']+)["'][^>]*>/i).flatten
    duplicates = Hash.new(0)
    lines.each_with_index do |(_number, line), index|
      heading = line[/\A {0,3}\#{1,6}\s+(.*?)\s*\#*\z/, 1]
      if !heading && lines.fetch(index + 1, [nil, ''])[1].match?(/\A {0,3}(?:=+|-+)\s*\z/)
        heading = line.strip
      end
      next unless heading && !heading.empty?

      slug = prose_text(heading, literal: false).downcase.gsub(/[^\p{L}\p{N}_\s-]/, '').gsub(/\s/, '-')
      count = duplicates[slug]
      found << (count.zero? ? slug : "#{slug}-#{count}")
      duplicates[slug] += 1
    end
    found
  end

  def link_errors(path, root, lines)
    visible = lines.map(&:last).join("\n").gsub(/(`+)(.*?)\1/m, 'LITERAL')
    references = inline_destinations(visible).map(&:last)
    lines.each do |_number, line|
      definition = reference_definition(line)
      references << destination(definition[2]) if definition
    end
    references.concat(visible.scan(/<[^>]+\b(?:href|src)=["']([^"']+)["'][^>]*>/i).flatten)
    references.uniq.filter_map do |reference|
      next if reference.empty? || reference.match?(/\A(?:https?:|mailto:|app:|\/\/)/i)

      if reference.match?(/\A(?:[a-z][a-z0-9+.-]*:|\/)/i)
        next "#{path}: reference escapes skill: #{reference}"
      end
      file, fragment = reference.split('#', 2)
      file = URI::DEFAULT_PARSER.unescape(file.split('?', 2).first || '')
      target = file.empty? ? path : File.expand_path(file, File.dirname(path))
      unless inside?(target, root)
        next "#{path}: reference escapes skill: #{reference}"
      end
      unless File.exist?(target)
        next "#{path}: missing bundled reference: #{reference}"
      end
      unless inside?(File.realpath(target), root)
        next "#{path}: reference escapes skill: #{reference}"
      end
      next unless fragment && !fragment.empty? && File.file?(target) && target.match?(/\.(?:md|markdown)\z/i)

      unless anchors(File.read(target)).include?(URI::DEFAULT_PARSER.unescape(fragment))
        "#{path}: missing markdown fragment: #{reference}"
      end
    end
  end

  def errors(skill_root, description)
    root = File.realpath(skill_root)
    found = []
    count = words(description)
    found << "#{skill_root}: description exceeds 25 words (#{count})" if count > DESCRIPTION_WORDS
    paths = Dir.glob(File.join(skill_root, '**', '*'), File::FNM_DOTMATCH).select { |path| File.file?(path) }
    paths.grep(/\.(?:md|markdown)\z/i).sort.each do |path|
      unless inside?(File.realpath(path), root)
        found << "#{path}: markdown escapes skill"
        next
      end
      content = File.read(path)
      lines = literal_lines(content)
      prose = units(lines)
      entry = File.expand_path(path) == File.join(File.expand_path(skill_root), 'SKILL.md')
      limit = entry ? ENTRY_WORDS : REFERENCE_WORDS
      total = prose.sum { |_line, _kind, text| words(text) }
      found << "#{path} exceeds #{limit} prose words (#{total})" if total > limit
      prose.each do |line, kind, text|
        next if kind == :heading

        text.split(/[.!?](?=\s|\z)/).each do |sentence|
          length = words(sentence)
          next if length <= SENTENCE_WORDS

          found << "#{path}:#{line}: sentence exceeds 20 words (#{length}): #{sentence.strip[0, 100]}"
        end
      end
      found.concat(link_errors(path, root, lines))
    end
    found
  end
end
