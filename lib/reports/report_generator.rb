# frozen_string_literal: true

module Reports
  class ReportGenerator
    include Filesystem::DirectoryService
    include Filesystem::ReportPersistor

    class InputFileNotFound < StandardError; end

    SUBREPORTS = [
      :list_of_questions
    ]

    def initialize(input:, output_directory: 'output', headers: true)
      raise InputFileNotFound unless File.exist?(input)

      setup_output_directory(output_directory)
      setup_report_subdirectory

      @data = CSV.parse(File.read(input), headers: headers)
      puts 'Generator initialized successfully'
    end

    def generate_report
      puts 'Generating report'
      generate_list_of_questions
    end
    
    private
    
    def generate_list_of_questions
      puts 'Generating the list of questions'
      questions = @data.headers().each_with_index.map do |header, index|
        "#{index +1}. " + header + "\n"
      end.join
      save_subreport(type: :list_of_questions, content: questions)
    end
  end
end
