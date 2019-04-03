# frozen_string_literal: true

module SentenceGenerator
  class WordChain
    PUNCTUATION = %w[. ? !].freeze

    attr_reader :word_tree, :starters
    def initialize
      @word_tree = {}
      @starters = []
    end

    def add(sentence)
      @starters |= [sentence.words.first]
      words_to_add = sentence.words.map(&:downcase)
      words_to_add[0..-2].each_with_index do |word, index|
        @word_tree[word] ||= Word.new(word)
        @word_tree[word].add words_to_add[index + 1]
      end
    end

    def generate_sentence
      sentence = [seed]
      until PUNCTUATION.include?(sentence.last)
        next_word = word_tree[sentence.last].next_word
        sentence << next_word
      end

      "#{sentence[0].capitalize} #{sentence[1..-2].join(' ')}#{sentence[-1]}"
    end

    private

    def seed
      starters.sample.downcase
    end
  end
end
