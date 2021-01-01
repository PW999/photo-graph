# frozen_string_literal: true

require_relative 'file_walker'
require_relative 'storage'
require_relative 'image_data'
require_relative 'log_config'
require 'exifr/jpeg'

log = Logging.logger[self]

fw = FileWalker.new('/mnt/p/From PWLumia640/')
storage = Storage.new('photo_stat')
fw.each do |full_path, file_name|
  begin
    image_data = ImageData.new(full_path, file_name, EXIFR::JPEG.new(full_path).exif.date_time)
    storage.store image_data if image_data.date?
  rescue EXIFR::MalformedJPEG => e
    log.error "Failed to get EXIF data from #{full_path}: #{e}"
  end
end
pp storage.grouped_by_date
