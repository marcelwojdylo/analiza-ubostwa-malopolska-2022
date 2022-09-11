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
        File.open(subreport.path, 'w+') do |file|
          file.persist_and_log(subreport.title)
          file.persist_and_log(subreport.title.gsub(/./, "~"))
          subreport.content.each do |element|
            file.persist_and_log(prettify(element))
          end
        end
      end
  
      def prettify(content_unit)
        case content_unit.class.name
        when Array
          content_unit
        when Hash
          content_unit
        when String
          return if content_unit.length < 2

          content_unit
        else
          raise InvalidContentFormat
        end
      end
    end
  end
end
