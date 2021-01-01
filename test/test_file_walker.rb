# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/file_walker'

class TestFileWalker < MiniTest::Test
  def test_read_current_dir
    file_walker = FileWalker.new('./test/data')

    assert_equal 2, file_walker.structure.size,
                 "At the root there\'s only two items, but got #{file_walker.structure.size}"

    refute_nil file_walker.structure['test.jpg'],
               'The item test.jpg should exists in the root'

    assert_instance_of String, file_walker.structure['test.jpg'],
                       'Expected test.jpg to be a file (string in the hash)'

    refute_nil file_walker.structure['data_1'],
               'The item data_1 should exists in the root'

    assert_instance_of Hash, file_walker.structure['data_1'],
                       'Expected data_1 to be directory (another hash in the hash)'

    assert_equal 3, file_walker.structure['data_1'].size,
                 "Expected that data_1 directory to contain 3 items,
                  but got #{file_walker.structure['data_1'].size}"
  end

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
