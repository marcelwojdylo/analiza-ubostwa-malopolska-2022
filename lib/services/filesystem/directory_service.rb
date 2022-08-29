# frozen_string_literal: true

require 'fileutils'

module Filesystem
  module DirectoryService
    def setup_output_directories
      puts 'Setting up output directories'
      @timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
      @output_directory = "#{PROJECT_DIRECTORY}/output"
      @run_subdirectory = "#{@output_directory}/#{@timestamp}_reports"
      setup_output_directory
      setup_run_subdirectory
    end
    
    def setup_output_directory
      puts 'Setting up main output directory'
      take(@output_directory)
    end

    def setup_run_subdirectory
      puts 'Setting up run subdirectory'
      take(@run_subdirectory)
    end
    
    def setup_report_subdirectory(report)
      puts 'Setting up report subdirectory'
      report_subdirectory = "#{@run_subdirectory}/#{report.type.to_s}"
      puts 'trying to take ' + report_subdirectory
      take(report_subdirectory)
      report_subdirectory
    end

    private

    def take(directory)
      return if File.directory?(directory)
      puts 'taking ' + directory
      FileUtils.mkdir_p(directory) 
    end
  end
end
