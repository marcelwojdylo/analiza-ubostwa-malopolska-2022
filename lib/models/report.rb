# frozen_string_literal: true

require './lib/services/filesystem/report_persistor'

class Report
  class SubreportsConstantMissing < StandardError; end
  attr_reader :report_subdirectory

  def initialize(input_file_path, generator)
    @input_file_path = input_file_path
    @generator = generator
    @report_subdirectory = @generator.setup_report_subdirectory(self)
    @subreports = []

    parse_input
  end

  def type
    self.class.name.underscore
  end

  def generate_report
    raise NotImplementedError
  end

  def add_subreport(type:, content:)
    @subreports << Subreport.new(
      report: self,
      type: type,
      content: content
    )
  end

  def persist_subreports
    @subreports.each do |subreport|
      Filesystem::ReportPersistor.save_subreport(subreport)
    end
  end

  def parse_input
    raise NotImplementedError
  end
end
