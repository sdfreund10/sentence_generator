# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

class SentenceTest < MiniTest::Test
  def test_initializes_with_empty_array_of_words_if_given_empty_string
    sentence = SentenceGenerator::Sentence.new
    assert_equal(
      [],
      sentence.words
    )
    sentence = SentenceGenerator::Sentence.new('')
    assert_equal(
      [],
      sentence.words
    )
  end

  def test_splits_initial_sentence
    statement = SentenceGenerator::Sentence.new('This is a sentence.')
    exclamation = SentenceGenerator::Sentence.new('This is also a sentence!')
    question = SentenceGenerator::Sentence.new('Is this a sentence?')

    assert_equal(
      %w[This is a sentence .],
      statement.words
    )
    assert_equal(
      %w[This is also a sentence !],
      exclamation.words
    )
    assert_equal(
      %w[Is this a sentence ?],
      question.words
    )
  end

  def test_raises_error_if_passed_string_not_ending_in_punctuation
    invalid_sentence = 'This is not a valid sentence'

    assert_raises(ArgumentError) do
      SentenceGenerator::Sentence.new(invalid_sentence)
    end
  end
end
