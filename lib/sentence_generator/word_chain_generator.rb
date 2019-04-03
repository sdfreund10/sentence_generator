# frozen_string_literal: true

module SentenceGenerator
  class WordChainGenerator
    def initialize(files)
      @files = files
    end

    def word_chain_for(character)
      chain = WordChain.new
      sentences_by_character[character].each do |sentence|
        chain.add sentence
      end
      chain
    end

    def sentences_by_character
      combine_file_data.transform_values do |sentences|
        sentences.map { |sentence| Sentence.new(sentence) }
      end
    end

    def combine_file_data
      @files.each_with_object(Hash.new([])) do |file, combined_data|
        file_lines = SentenceGenerator::Script.new(
          File.read(file)
        ).lines_by_character
        combined_data.merge!(file_lines) do |_character, all_lines, new_lines|
          all_lines + new_lines
        end
      end
    end
  end
end
