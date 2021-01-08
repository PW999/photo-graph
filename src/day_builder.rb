# frozen_string_literal: tr

require 'date'

class DayBuilder
  def initialize(statistics, min_year, max_year)
    @statistics = statistics
    @min_year = min_year
    @max_year = max_year
    @data = build
    pp @data
  end

  private

  def build
    data = {}
    Date.new(@min_year).step(Date.new(@max_year + 1)).each do |date|
      break if date.year == @max_year + 1

      date_as_string = date.strftime('%F')

      stat = @statistics.select { |s| s[:date_taken] == date_as_string }
      data[date_as_string] = { date: date, stat: (stat.size.zero? ? 0 : stat[0][:count]) }
    end
    data
  end
end
