# frozen_string_literal: true

module Reports
  class ReportGenerator
    include Filesystem::DirectoryService

    class InputFileNotFound < StandardError; end

    def initialize(sources)
      @reports = []
      @sources = sources
      setup_output_directories
      load_sources
      log 'Generator initialized successfully'
    end

    def generate_reports
      @reports.map(&:generate_report)
    end

    private

    def load_sources
      log 'Loading sources'
      @sources.each do |source|
        raise InputFileNotFound unless File.exist?(source)

        csv_paths = Dir[File.join(source, '**/*.csv')].sort
        load_csv(csv_paths)
      end
    end

    def load_csv(csv_paths)
      csv_paths.each do |file_path|
        log "loading #{file_path}"
        if file_path.include?('instytucje')
          @reports << InstitutionsReport.new(file_path, self)
        elsif file_path.include?('populacja')
          @reports << PopulationReport.new(file_path, self)
        end
      end
    end
  end
end
