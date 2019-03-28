# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

module SentenceGenerator
  class WordTest < Minitest::Test
    def test_add_adds_new_words_to_transition_counts
      word = SentenceGenerator::Word.new('test')
      word.add('next')
      assert_equal(word.transition_counts, 'next' => 1)
    end

    def test_add_adds_to_the_count_of_existing_words
      word = SentenceGenerator::Word.new('test')
      2.times { word.add('next') }
      assert_equal(word.transition_counts, 'next' => 2)
    end

    def test_transition_probabilities_converts_counts_to_probabilities
      word = SentenceGenerator::Word.new('test')
      2.times { word.add('next') }
      3.times { word.add('word') }
      assert_equal(
        word.transition_probabilities,
        'next' => 0.4, 'word' => 0.6
      )
    end

    def test_cumulative_transition_probabilities_calcs_cumulative_probs
      word = SentenceGenerator::Word.new('test')
      2.times { word.add('next') }
      3.times { word.add('word') }
      assert_equal(
        word.cumulative_transition_probabilities,
        'next' => 0.4, 'word' => 1.0
      )
    end

    def test_next_word_randomly_selects_a_word
      word = SentenceGenerator::Word.new('test')
      1.times { word.add('add') }
      2.times { word.add('new') }
      1.times { word.add('word') }
      word.stub(:rand, 0.1) do
        assert_equal(word.next_word, 'add')
      end
      word.stub(:rand, 0.3) do
        assert_equal(word.next_word, 'new')
      end
      word.stub(:rand, 0.8) do
        assert_equal(word.next_word, 'word')
      end
    end

    def test_produces_correct_distribution
      word = SentenceGenerator::Word.new('test')
      1.times { word.add('add') }
      2.times { word.add('new') }
      1.times { word.add('word') }
      random_words = (1..1_000).map { word.next_word }
      # because randomness, each of the following will fail 3% of the time
      assert_in_delta(
        random_words.count { |word| word == 'add' },
        250,
        30
      )
      assert_in_delta(
        random_words.count { |word| word == 'new' },
        500,
        35
      )
      assert_in_delta(
        random_words.count { |word| word == 'word' },
        250,
        30
      )
    end
  end
end
