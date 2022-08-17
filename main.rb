# frozen_string_literal: true

puts 'Initializing...'
require_relative 'initialize'

puts 'Creating generator'
generator = Reports::ReportGenerator.new(SOURCES)
puts 'Running report generator'
generator.generate_reports
