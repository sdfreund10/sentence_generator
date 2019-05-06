# frozen_string_literal: true

require_relative '../lib/sentence_generator'
require_relative './script_parser'

class WordChainGenerator
  attr_reader :character_lines

  def initialize
    @character_lines = Hash.new([])
    @character_chains = {}
  end

  def word_chain_for(character)
    return @character_chains[character] unless @character_chains[character].nil?
    chain = SentenceGenerator::WordChain.new
    lines_for_character = @character_lines.fetch(character)
    lines_for_character.each do |sentence|
      next unless %w[. ? !].include?(sentence[-1])
      chain.add SentenceGenerator::Sentence.new(sentence)
    end
    @character_chains[character] = chain
    chain
  end

  def characters
    @character_lines.keys
  end

  def sentences_by_character
    @character_lines.transform_values do |sentences|
      sentences.map { |sentence| SentenceGenerator::Sentence.new(sentence) }
    end
  end

#  def combine_file_data
#    @files.each_with_object(Hash.new([])) do |file, combined_data|
#      file_lines = Script.new(
#        file.read
#      ).lines_by_character
#      combined_data.merge!(file_lines) do |_character, all_lines, new_lines|
#        all_lines + new_lines
#      end
#    end
#  end

  def add_file_data(file)
    lines = Script.new(file.read).lines_by_character
    @character_lines.merge!(lines) do |_char, all_lines, new_lines|
      all_lines + new_lines
    end
  end
end
