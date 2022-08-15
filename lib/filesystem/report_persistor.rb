# frozen_string_literal: true

require 'fileutils'

module Filesystem
  module ReportPersistor
    class UnknownReportType < StandardError; end
    def save_subreport(type:, content:'')
      raise UnknownSubreportType unless Reports::ReportGenerator::SUBREPORTS.include?(type)

      subreport_title = type.to_s.tr('_', ' ').capitalize
      File.open("#{@report_subdirectory}/#{type.to_s}.txt", 'w+') do |file|
        file.write(subreport_title)
        puts subreport_title
        file.write(content)
        puts content
      end

      puts "Persisted #{subreport_title}"
      puts "Wrote to file #{@report_subdirectory}/#{type.to_s}"
      
    end
  end
end
