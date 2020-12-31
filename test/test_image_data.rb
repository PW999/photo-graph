# frozen_string_literal: true

require 'minitest/autorun'
require 'exifr/jpeg'
require_relative '../src/image_data'

class TestImageData < MiniTest::Test
  def test_create_image_data
    test_file = File.join(__dir__, 'test_image/4143436615_ae3c938de3_o-1920.jpg')
    image_data = ImageData.new('dir/file', 'file', EXIFR::JPEG.new(test_file).exif.date_time_original)

    assert_equal 'dir/file', image_data.full_path
    assert_equal 'file', image_data.file_name
    assert_equal Date.new(2009, 11, 20), image_data.date_taken
    assert_equal Time.new(2009, 11, 20, 14, 50, 29), image_data.timestamp_taken
  end
end
