# frozen_string_literal: true

require 'time'

class ImageData
  attr_reader :full_path, :file_name, :timestamp_taken, :date_taken, :make, :model

  @full_path
  @file_name
  @timestamp_taken
  @date_taken
  @make
  @model

  def initialize(full_path, file_name, exif)
    @full_path = full_path
    @file_name = file_name
    return if exif.nil? || exif.date_time_original.nil?

    @make = exif.make
    @model = exif.model
    @timestamp_taken = exif.date_time_original
    @date_taken = exif.date_time_original.to_datetime.to_date
  end

  def date?
    !@timestamp_taken.nil?
  end

  def to_a
    [@full_path,
     @file_name,
     @timestamp_taken.strftime('%F %T'),
     @date_taken.strftime('%F'),
     @make,
     @model]
  end
end
