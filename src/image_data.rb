# frozen_string_literal: true

require 'time'

class ImageData

  attr_reader :full_path, :file_name, :timestamp_taken, :date_taken

  @full_path
  @file_name
  @timestamp_taken
  @date_taken

  def initialize(full_path, file_name, timestamp_taken)
    @full_path = full_path
    @file_name = file_name
    return if timestamp_taken.nil?

    @timestamp_taken = timestamp_taken
    @date_taken = timestamp_taken.to_datetime.to_date
  end

end
