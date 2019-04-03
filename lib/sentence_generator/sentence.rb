# frozen_string_literal: true

module SentenceGenerator
  class Sentence
    attr_reader :words

    def initialize(initial_value = '')
      @words = split_string(initial_value)
    end

    def split_string(string)
      return [] if string.empty?

      if %w[. ? !].include? string[-1]
        string[0..-2].split + [string[-1]]
      else
        raise ArgumentError, 'Sentence must have ending punctuation'
      end
    end
  end
end
