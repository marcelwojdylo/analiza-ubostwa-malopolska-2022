# frozen_string_literal: true

require 'fileutils'

module Filesystem
  module DirectoryService
    def setup_output_directories
      setup_output_directory
      setup_run_subdirectory
      setup_report_subdirectory
    end
    
    def setup_output_directory
      @output_directory = "#{PROJECT_DIRECTORY}/output"
      take(@output_directory)
    end

    def setup_run_subdirectory
      timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
      @run_subdirectory = "#{@output_directory}/#{timestamp}_reports"
      take(@run_subdirectory)
    end

    def setup_report_subdirectory
      @report_subdirectory = "#{@run_subdirectory}/#{self.type.to_s}"
      take(@report_subdirectory)
    end

    private

    def take(directory)
      FileUtils.mkdir_p(directory) unless File.directory?(directory)
    end
  end
end
