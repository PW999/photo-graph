# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../src/storage'
require_relative '../src/image_data'

class TestStorage < MiniTest::Test
  def setup
    File.delete 'it.db' if File.file? 'it.db'
    @storage = Storage.new 'it'
  end

  def teardown
    File.delete 'it.db' if File.file? 'it.db'
  end

  def test_storage
    image_data = ImageData.new('/home/test/image_1.jpg', 'image_1.jpg',
                               get_exif_mock(Time.new(2021, 1, 1, 17, 53, 12), '', ''))
    @storage.store image_data

    storage_data = @storage.get_by_path_as_hash '/home/test/image_1.jpg'

    assert_equal '/home/test/image_1.jpg', storage_data['full_path']
    assert_equal 'image_1.jpg', storage_data['file_name']
    assert_equal '2021-01-01 17:53:12', storage_data['ts_taken']
    assert_equal '2021-01-01', storage_data['date_taken']
  end

  def test_count
    data = [
      ImageData.new('/home/test/image_1.jpg', 'image_1.jpg',
                    get_exif_mock(Time.new(2021, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_2.jpg', 'image_2.jpg',
                    get_exif_mock(Time.new(2020, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_3.jpg', 'image_3.jpg',
                    get_exif_mock(Time.new(2019, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_4.jpg', 'image_4.jpg',
                    get_exif_mock(Time.new(2021, 1, 1, 15, 53, 12), '', '')),
      ImageData.new('/home/test/image_5.jpg', 'image_5.jpg',
                    get_exif_mock(Time.new(2021, 1, 1, 16, 53, 12), '', ''))
    ]

    data.each { |image| @storage.store image }

    statistics = @storage.fetch_grouped_by_date
    assert_equal 3, find_stat_by_date(statistics, '2021-01-01')['count']
    assert_equal 1, find_stat_by_date(statistics, '2020-01-01')['count']
    assert_equal 1, find_stat_by_date(statistics, '2019-01-01')['count']
  end

  def test_min_max_year
    data = [
      ImageData.new('/home/test/image_1.jpg', 'image_1.jpg',
                    get_exif_mock(Time.new(1971, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_2.jpg', 'image_2.jpg',
                    get_exif_mock(Time.new(3001, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_3.jpg', 'image_3.jpg',
                    get_exif_mock(Time.new(2019, 1, 1, 17, 53, 12), '', '')),
      ImageData.new('/home/test/image_4.jpg', 'image_4.jpg',
                    get_exif_mock(Time.new(2021, 1, 1, 15, 53, 12), '', '')),
      ImageData.new('/home/test/image_5.jpg', 'image_5.jpg',
                    get_exif_mock(Time.new(2021, 1, 1, 16, 53, 12), '', ''))
    ]

    data.each { |image| @storage.store image }

    assert_equal @storage.fetch_start_year, 1971
    assert_equal @storage.fetch_end_year, 3001
  end

  private

  def get_exif_mock(date, make, model)
    mock = MiniTest::Mock.new
    mock.expect(:date_time_original, date)
    mock.expect(:date_time_original, date)
    mock.expect(:date_time_original, date)
    mock.expect(:make, make)
    mock.expect(:model, model)
    mock.expect(:nil?, false)
  end

  def find_stat_by_date(arr, date)
    arr.each do |date_stat|
      return date_stat if date_stat['date_taken'] == date
    end
  end
end
