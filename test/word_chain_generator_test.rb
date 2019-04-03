# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

class WordChainGeneratorTest < MiniTest::Test
  def test_combine_file_data_merges_line_hashes_from_multiple_files
    generate_files do |files|
      generator = SentenceGenerator::WordChainGenerator.new(files)

      assert_equal(
        { 'A' => ['This is a line.', 'This is another line.'],
          'B' => ['Is it now?'] },
        generator.combine_file_data
      )
    end
  end

  def test_sentences_by_character_parses_sentences_for_each_character
    generate_files do |files|
      generator = SentenceGenerator::WordChainGenerator.new(files)

      a_senences = generator.sentences_by_character['A']

      assert(
        a_senences.all? { |obj| obj.is_a? SentenceGenerator::Sentence },
        'One or more of the generated objects is not a Sentence'
      )

      assert_equal(
        %w[This is a line .],
        a_senences.first.words
      )
    end
  end

  def test_word_chain_for_returns_a_word_chain_for_the_given_character
    generate_files do |files|
      generator = SentenceGenerator::WordChainGenerator.new(files)
      chain = generator.word_chain_for 'A'
      assert(
        chain.is_a?(SentenceGenerator::WordChain),
        'result is not an instance of WordChain'
      )
      assert_equal(
        ['This'],
        chain.starters,
        'the word chain does not return the expected starting words'
      )
      assert_equal(
        %w[this is a line another],
        chain.word_tree.keys,
        'this word tree does not contain the expect words'
      )
    end
  end

  def generate_files
    file1 = File.open('test_file_1.txt', 'w')
    file1.puts("A: This is a line.\nB: Is it now?")
    file1.close
    file2 = File.open('test_file_2.txt', 'w')
    file2.puts('A: This is another line.')
    file2.close

    yield [file1.path, file2.path]
  ensure
    FileUtils.rm('test_file_1.txt')
    FileUtils.rm('test_file_2.txt')
  end
end
