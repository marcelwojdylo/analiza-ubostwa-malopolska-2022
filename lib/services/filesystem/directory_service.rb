# frozen_string_literal: true

require 'fileutils'

module Filesystem
  module DirectoryService
    def setup_output_directories
      log 'Setting up output directories'
      @timestamp = Time.now.utc.strftime('%Y%m%d%H%M%S')
      @output_directory = "/output"
      @run_subdirectory = "#{@output_directory}/#{@timestamp}_reports"
      setup_output_directory
      setup_run_subdirectory
    end

    def setup_output_directory
      log 'Setting up main output directory'
      take(@output_directory)
    end

    def setup_run_subdirectory
      log 'Setting up run subdirectory'
      take(@run_subdirectory)
    end

    def setup_report_subdirectory(report)
      log 'Setting up report subdirectory'
      report_subdirectory = "#{@run_subdirectory}/#{report.type}"
      log "trying to take #{report_subdirectory}"
      take(report_subdirectory)
      report_subdirectory
    end

    private

    def take(directory)
      return if File.directory?(directory)

      log "taking #{directory}"
      FileUtils.mkdir_p(PROJECT_DIRECTORY + directory)
    end
  end
end
