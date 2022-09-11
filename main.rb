# frozen_string_literal: true

puts 'Initializing...'
require_relative 'initialize'

log 'Creating generator'
generator = Reports::ReportGenerator.new(SOURCES)
log 'Running report generator'
generator.generate_reports
