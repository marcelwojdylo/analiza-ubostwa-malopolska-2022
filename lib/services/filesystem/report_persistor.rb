# frozen_string_literal: true

require 'fileutils'

module Filesystem
  class ReportPersistor
    class << self
      def save_subreport(subreport)
        log "Persisting subreport: #{subreport.title}"
        log "Writing to #{subreport.path}"
        persist_file(subreport)

        log 'Subreport persisted successfully'
      end

      private

      def persist_file(subreport)
        File.open(PROJECT_DIRECTORY + subreport.path, 'w+') do |file|
          file.puts(subreport.title)
          file.puts(subreport.title.gsub(/./, '~'))
          if subreport.question.present?
            file.puts(subreport.question)
            file.puts(subreport.title.gsub(/./, '~'))
          end
          file.puts("\n")
          subreport.content.each do |element|
            file.puts(prettify(element))
          end
        end
      end

      def prettify(content_unit)
        prettified = content_unit
        case content_unit
        when Array
          prettified = content_unit.map do |el|
            "#{el}\n"
          end
        when Hash
          prettified = content_unit.map do |key, value|
            "#{key}:\n    #{value}\n"
          end
          prettified << '~~~~~~~~~~~~'
          prettified << "\n"
        when String
          return if content_unit.length < 2
        end
        prettified
      end
    end
  end
end
