# frozen_string_literal: true

module Reports
  class ReportGenerator

    class InputFileNotFound < StandardError; end

    def initialize(sources)
      @reports = []
      @sources = sources
      load_sources
      puts 'Generator initialized successfully'
    end
    
    def generate_reports
      
    end
    
    private
    
    def load_sources
      @sources.each do |source|
        raise InputFileNotFound unless File.exist?(source)
        Dir[File.join(source, '**/*.csv')].sort.each do |file_path|
          if file_path.include?('instytucje')
            @reports << InstitutionsReport.new(file_path)
          elsif file_path.include?('populacja')
            @reports << PopulationReport.new(file_path)
          end
        end
      end
    end
  end
end
