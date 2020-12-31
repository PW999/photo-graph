# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/file_walker'

class TestFileWalker < MiniTest::Test

  def test_read_current_dir
    file_walker = FileWalker.new('./test/data')
    puts file_walker.structure

    assert_equal 2, file_walker.structure.size,
                 "At the root there\'s only two items, but got #{file_walker.structure.size}"

    refute_nil file_walker.structure['test.txt'],
               'The item test.txt should exists in the root'

    assert_instance_of String, file_walker.structure['test.txt'],
                       'Expected test.txt to be a file (string in the hash)'

    refute_nil file_walker.structure['data_1'],
               'The item data_1 should exists in the root'

    assert_instance_of Hash, file_walker.structure['data_1'],
                       'Expected data_1 to be directory (another hash in the hash)'

    assert_equal 3, file_walker.structure['data_1'].size,
                 "Expected that data_1 directory to contain 3 items,
                  but got #{file_walker.structure['data_1'].size}"
  end
end
