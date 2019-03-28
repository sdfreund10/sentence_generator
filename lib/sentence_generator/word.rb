# frozen_string_literal: true

module SentenceGenerator
  class Word
    attr_reader :value, :transition_counts

    def initialize(value)
      @value = value
      @transition_counts = Hash.new(0)
    end

    def add(next_word)
      @transition_counts[next_word] += 1
    end

    def next_word
      seed = rand
      cumulative_transition_probabilities.find do |_word, prob|
        seed < prob
      end.first
    end

    def transition_probabilities
      @transition_counts.transform_values do |word_count|
        word_count / total_word_count
      end
    end

    def cumulative_transition_probabilities
      cumulative_sum = 0
      @transition_counts.transform_values do |word_count|
        cumulative_sum += word_count
        cumulative_sum / total_word_count
      end
    end

    def total_word_count
      # sum converts hash to array of 2D arrays, [key, value]
      @transition_counts.sum(&:last).to_f
    end
  end
end
