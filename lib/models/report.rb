# frozen_string_literal: true
require './lib/services/filesystem/directory_service.rb'

class Report
  include Filesystem::DirectoryService

  def initialize(input_file_path)
    binding.pry
    @input_file_path = input_file_path
    setup_output_directories
  end

  def type
    raise NotImplementedError
  end
  
  def subreports
    raise NotImplementedError
  end

  def parse_input
    raise NotImplementedError
  end
end
