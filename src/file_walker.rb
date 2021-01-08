# frozen_string_literal: true

require_relative 'log_config'
require 'find'

class FileWalker
  include Enumerable

  attr_reader :structure

  def initialize(root)
    @log = Logging.logger[self]
    @root = root
    @items = 0
    @structure = {}
    Find.find(root) do |path|
      next if FileTest.directory?(path)

      next unless path[-3, 3].downcase == 'jpg' || path[-4, 4].downcase == 'jpeg'

      @structure[path] = File.basename(path)
      @items += 1
    end
    @log.info "Walker found #{@items} files and folders in #{root}"
  end

  def each(&block)
    @structure.each do |key, val|
      block.call key, val
    end
  end
end
