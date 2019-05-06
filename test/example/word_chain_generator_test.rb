# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../example/word_chain_generator'

class WordChainGeneratorTest < MiniTest::Test
  def test_add_file_data_data_merges_line_hashes_from_multiple_files
    generate_files do |files|
      generator = WordChainGenerator.new
      files.each { |f| generator.add_file_data f }

      assert_equal(
        { 'A' => ['This is a line.', 'This is another line.'],
          'B' => ['Is it now?'] },
        generator.character_lines
      )
    end
  end

  def test_sentences_by_character_parses_sentences_for_each_character
    generate_files do |files|
      generator = WordChainGenerator.new
      files.each { |f| generator.add_file_data f }

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
      generator = WordChainGenerator.new
      files.each { |f| generator.add_file_data f }
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

  def test_word_chain_for_returns_a_word_chain_for_the_given_character
    generate_files do |files|
      generator = WordChainGenerator.new
      files.each { |f| generator.add_file_data f }
      assert_equal(
        %w(A B),
        generator.characters
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

    yield [File.open(file1.path,'r'), File.open(file2.path, 'r')]
  ensure
    FileUtils.rm('test_file_1.txt')
    FileUtils.rm('test_file_2.txt')
  end
end
