# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

class WordChainTest < MiniTest::Test
  def test_add_sentence_adds_to_chain
    chain = SentenceGenerator::WordChain.new
    sentence = SentenceGenerator::Sentence.new('This is a sentence.')
    assert_equal(
      {},
      chain.word_tree
    )
    chain.add sentence
    assert_equal(
      %w[this is a sentence],
      chain.word_tree.keys
    )

    assert(
      chain.word_tree.values.all? { |word| word.is_a? SentenceGenerator::Word },
      'One of more of the word_tree values is not an instance of Word'
    )
  end

  def test_add_sentence_adds_to_starters
    chain = SentenceGenerator::WordChain.new
    sentence = SentenceGenerator::Sentence.new('This is a sentence.')
    assert_equal(
      [],
      chain.starters
    )
    chain.add sentence
    assert_equal(
      %w[This],
      chain.starters
    )
  end

  def test_generate_sentence_randomly_generates_sentence_from_word_tree
    chain = SentenceGenerator::WordChain.new
    chain.add(
      SentenceGenerator::Sentence.new('This is a sentence.')
    )
    chain.add(
      SentenceGenerator::Sentence.new('This is another sentence.')
    )

    random_sentence = chain.generate_sentence
    equals_first_sentence = random_sentence == 'This is a sentence.'
    equals_second_sentence = random_sentence == 'This is another sentence.'
    assert(
      equals_first_sentence || equals_second_sentence,
      'generated sentence does not match either of the training sentences ' \
        "(#{random_sentence})"
    )
  end
end
