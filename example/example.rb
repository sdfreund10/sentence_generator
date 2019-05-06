# frozen_string_literal: true
require_relative '../lib/sentence_generator'
require_relative './word_chain_generator'
require 'zip'

class SentenceGenerator::Example
  attr_reader :generator

  def initialize
    setup!
  end

  def setup!
    zip = Zip::File.open('example/scripts/scripts.zip')# .select do |file|
    #   file.name.match? /\AStarTrek-/
    # end
    @generator = WordChainGenerator.new
    files = zip.entries.map do |file|
      @generator.add_file_data(file.get_input_stream)
    end

  end

  def generate_sentence_for(character)
    @generator.word_chain_for(character).generate_sentence
  end

  def word_chain_for(character)
    @generator.word_chain_for(character)
  end
end

puts SentenceGenerator::Example.new.generate_sentence_for("KIRK")
