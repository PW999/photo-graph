# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/file_walker'

class TestFileWalker < MiniTest::Test
  def test_each
    count = 0
    paths_encountered = []
    files_encountered = []

    file_walker = FileWalker.new('./test/data')
    file_walker.each do |path, file|
      paths_encountered << path
      files_encountered << file
      count += 1
    end

    assert_equal 4, count, 'Expected each to go through 4 files'

    assert_includes paths_encountered, './test/data/test.jpg'
    assert_includes paths_encountered, './test/data/data_1/test.jpg'
    assert_includes paths_encountered, './test/data/data_1/test2.jpg'
    assert_includes paths_encountered, './test/data/data_1/data_2/text_1.jpg'

    assert_includes files_encountered, 'test.jpg'
    assert_includes files_encountered, 'test2.jpg'
    assert_includes files_encountered, 'text_1.jpg'
  end
end
