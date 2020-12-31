# frozen_string_literal: true

require_relative 'log_config'

class FileWalker
  include Enumerable

  attr_reader :structure

  def initialize(root)
    @log = Logging.logger[self]
    @root = root
    @items = 0
    @structure = build(root)
    @log.info "Walker found #{@items} files and folders"
  end

  def each(&block)
    @structure.each do |key, val|
      flatten(@root, key, val, &block)
    end
  end

  private

  def flatten(current_path, next_path, next_path_content, &block)
    if next_path_content.is_a? String
      return block.call File.join(current_path, next_path), next_path_content
    end

    next_path_content.each do |key, val|
      flatten(File.join(current_path, next_path), key, val, &block)
    end
  end

  def build(path)
    @log.debug("Iterating into #{path}")
    root = Dir.new(path)
    current_dir_structure = {}
    root.each_child do |child|
      @items += 1
      path_from_root = File.join(path, child)
      @log.debug("Inspecting #{path_from_root}, isDir: #{Dir.exist? path_from_root}")
      current_dir_structure[child] = Dir.exist?(path_from_root) ? build(path_from_root) : child
    end
    current_dir_structure
  end
end
