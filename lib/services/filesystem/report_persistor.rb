# frozen_string_literal: true

require 'fileutils'

module Filesystem
  class ReportPersistor
    class UnknownReportType < StandardError; end

    def initialize(report)
      @report = report
    end

    def save_subreport(type:, content: '')
      raise UnknownSubreportType unless InstitutionsReport.subreports.include?(type)
      
      subreport_title = type.to_s.tr('_', ' ').capitalize
      puts "Persisting subreport: #{subreport_title}"
      path = "#{@report.report_subdirectory}/#{type}.txt"
      puts "Writing to #{path}"
      File.open(path, 'w+') do |file|
        file.puts(subreport_title)
        puts subreport_title
        file.puts(content)
        puts content
      end

      puts "Subreport persisted successfully"
      puts "Wrote to #{path}"
    end
  end
end
