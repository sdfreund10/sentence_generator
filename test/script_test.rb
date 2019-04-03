# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/sentence_generator'

class ScriptTest < MiniTest::Test
  def test_lines_separates_script_into_lines
    text = "A: this is a test script\r\nB: it has two lines"
    script = SentenceGenerator::Script.new(text)
    assert_equal(script.lines, text.split("\r\n"))
  end

  def test_lines_by_character_returns_hash_of_each_characters_lines
    text = "A: Hey!\r\nB: Hi...\r\nA: K bye"
    script = SentenceGenerator::Script.new(text)
    assert_equal(
      {
        'A' => ['Hey!', 'K bye'],
        'B' => ['Hi...']
      },
      script.lines_by_character
    )
  end

  def test_lines_by_character_removes_parenthesized_nots
    text = 'A (quietly): That dude...'
    script = SentenceGenerator::Script.new(text)
    assert_equal(
      { 'A' => ['That dude...'] },
      script.lines_by_character
    )
  end

  def test_lines_by_character_does_not_add_lines_with_no_quote
    text = '(this script has no quotes)'
    script = SentenceGenerator::Script.new(text)
    assert_equal(
      {},
      script.lines_by_character
    )
  end

  def test_lines_by_character_combines_quotes_over_multiple_lines
    text = "A: This quote spans\r\n2 lines"
    script = SentenceGenerator::Script.new(text)
    assert_equal(
      { 'A' => ['This quote spans 2 lines'] },
      script.lines_by_character
    )
  end
end
