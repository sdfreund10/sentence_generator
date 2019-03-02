# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

class WordChainGeneratorTest < MiniTest::Unit::TestCase
  def test_combine_file_data_merges_line_hashes_from_multiple_files
    generate_files do |files|
      generator = SentenceGenerator::WordChainGenerator.new(files)

      assert_equal(
        { "A" => ["This is a line.", "This is another line."],
          "B" => ["Is it now?"] },
        generator.combine_file_data
      )
    end
  end

  def test_word_chains_by_character_creates_chain_for_each_character_in_files
    generate_files do |files|
      generator = SentenceGenerator::WordChainGenerator.new(files)

      character_a_chain = generator.word_chains_by_character["A"]
    end
  end

  def generate_files
    file_1 = File.open("test_file_1.txt", "w")
    file_1.puts("A: This is a line.\nB: Is it now?")
    file_1.close
    file_2 = File.open("test_file_2.txt", "w")
    file_2.puts("A: This is another line.")
    file_2.close

    yield [file_1.path, file_2.path]
  ensure
    FileUtils.rm("test_file_1.txt")
    FileUtils.rm("test_file_2.txt")
  end
end

