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
          file.persist_and_log(subreport.title)
          file.puts(subreport.title.gsub(/./, "~"))
          file.puts("\n")
          subreport.content.each do |element|
            file.puts(prettify(element))
          end
        end
      end
      
      def prettify(content_unit)
        prettified = content_unit
        if content_unit.is_a? Array
          prettified = content_unit.map do |el|
            "#{el}\n"
          end
        elsif content_unit.is_a? Hash
          prettified = content_unit.map do |key, value|
            "#{key}:\n    #{value}\n"
          end
          prettified << "~~~~~~~~~~~~"
          prettified << "\n"
        elsif content_unit.is_a? String
          return if content_unit.length < 2
        end
        return prettified
      end
    end
  end
end
