# frozen_string_literal: true

module SentenceGenerator
  class Script
    def initialize(text)
      @text = text
    end

    def lines_by_character
      lines_by_character = Hash.new []
      parsed_lines do |line|
        parsed_line = line.split(/\s?: /)
        next if parsed_line.length < 2

        character = parsed_line.first
        lines_by_character[character] += [parsed_line.last]
      end
      lines_by_character
    end

    def lines
      @text.gsub(/\(.+\)/, '')
           .gsub(/\[.+\]/, '')
           .gsub(/\r\n/, ' ')
           .split(/\s+(?=\w+\s?:)/)
    end

    def parsed_lines
      lines.each do |line|
        parsed_line = line.gsub(/\s\s+/, ' ')
                          .gsub(/^\s+|\s+$/, '')
        yield parsed_line
      end
    end
  end
end
