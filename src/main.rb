# frozen_string_literal: true

require_relative 'file_walker'
require_relative 'storage'
require_relative 'image_data'
require_relative 'log_config'
require 'exifr/jpeg'

log = Logging.logger[self]

def skip_path(path)
  return false if (/.*\[(?<photographer>.*)\]/ =~ path).nil?

  photographer.downcase['phillip'].nil? && photographer.downcase['ikke'].nil?
end
paths = ['/mnt/p/foto\'s', '/mnt/p/From Mi9t', '/mnt/p/From PWLumia640', '/mnt/p/From PWVenuePro'].freeze
storage = Storage.new('photo_stat')

paths.each do |path|
  fw = FileWalker.new(path)
  fw.each do |full_path, file_name|
    begin
      (log.info("Skip #{full_path}"); next) if skip_path(full_path)

      image_data = ImageData.new(full_path, file_name, EXIFR::JPEG.new(full_path).exif)
      storage.store image_data if image_data.date?
    rescue EXIFR::MalformedJPEG => e
      log.error "Failed to get EXIF data from #{full_path}: #{e}"
    rescue NoMethodError => e
      log.error "Problem reading data from #{full_path}: #{e}"
    end
  end
end
pp storage.grouped_by_date
