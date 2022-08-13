# frozen_string_literal: true

module Reports
  class ReportGenerator
    include Filesystem::DirectoryService
    class InputFileNotFound < StandardError; end

    def initialize(input:, output_directory: 'output', headers: true)
      raise InputFileNotFound unless File.exist?(input)

      setup_output_directory(output_directory)
      setup_report_subdirectory

      @data = CSV.parse(File.read(input), headers: headers)
      @headers = @data.headers
    end

    def generate_report; end
  end
end
