# frozen_string_literal: true

require_relative 'log_config'

class FileWalker

  attr_reader :structure

  def initialize(root)
    @log = Logging.logger[self]
    @root = root
    @structure = build(root)
  end

  def build(path)
    @log.debug("Iterating into #{path}")
    root = Dir.new(path)
    current_dir_structure = {}
    root.each_child do |child|
      path_from_root = File.join(path, child)
      @log.debug("Inspecting #{path_from_root}, isDir: #{Dir.exist? path_from_root}")
      current_dir_structure[child] = Dir.exist?(path_from_root) ? build(path_from_root) : child
    end
    current_dir_structure
  end
end
