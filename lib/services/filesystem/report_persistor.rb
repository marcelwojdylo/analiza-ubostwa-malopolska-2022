# frozen_string_literal: true

require 'fileutils'

module FileCustomMethods
  def persist_and_log(string)
    log string
    puts(string)
  end
end

File.class_eval { include FileCustomMethods }

module Filesystem
  class ReportPersistor
    class UnknownReportType < StandardError; end

    def initialize(report)
      @report = report
    end

    def save_subreport(type:, content: '')
      raise UnknownSubreportType unless InstitutionsReport.subreports.include?(type)

      subreport_title = type.to_s.tr('_', ' ').capitalize
      log "Persisting subreport: #{subreport_title}"
      path = "#{@report.report_subdirectory}/#{type}.txt"
      log "Writing to #{path}"
      File.open(path, 'w+') do |file|
        file.persist_and_log(subreport_title)
        file.persist_and_log(subreport_title.gsub(/./, "~"))
        file.persist_and_log(content)
      end

      log 'Subreport persisted successfully'
      log "Wrote to #{path}"
    end

    private 

  end
end
