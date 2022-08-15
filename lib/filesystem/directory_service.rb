# frozen_string_literal: true

require 'fileutils'

module Filesystem
  module DirectoryService
    def setup_output_directory(output)
      @output_directory = "#{PROJECT_DIRECTORY}/#{output}"
      take(@output_directory)
    end
    
    def setup_report_subdirectory
      timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
      @report_subdirectory = "#{@output_directory}/#{timestamp}_report"
      take(@report_subdirectory)
    end
    
    private 
    
    def take(directory)
      FileUtils.mkdir_p(directory) unless File.directory?(directory)
    end
  end
end
