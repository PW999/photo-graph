# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../src/day_builder'

class TestDayBuilder < MiniTest::Test
  def test_builder
    test_data = [
      { date_taken: '2020-01-01', count: 1 },
      { date_taken: '2019-05-01', count: 10 },
      { date_taken: '2019-02-04', count: 5 },
      { date_taken: '2020-12-30', count: 3 }
    ]

    builder = DayBuilder.new(test_data, 2019, 2020)
  end
end
