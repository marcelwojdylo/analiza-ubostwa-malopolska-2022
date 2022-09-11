# frozen_string_literal: true

require './lib/services/filesystem/report_persistor'

class Report
  class SubreportsConstantMissing < StandardError; end
  attr_reader :report_subdirectory

  def initialize(input_file_path, generator)
    @input_file_path = input_file_path
    @generator = generator
    @report_subdirectory = @generator.setup_report_subdirectory(self)
    @persistor = Filesystem::ReportPersistor.new(self)

    parse_input
  end

  def type
    self.class.name.underscore
  end

  def generate_report
    raise NotImplementedError
  end

  def parse_input
    raise NotImplementedError
  end
end
