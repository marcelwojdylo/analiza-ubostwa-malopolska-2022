# frozen_string_literal: true

puts 'Initializing...'
require_relative 'initialize'

sources = [
  'data/instytucje.csv'
]

output_directory = 'output'

puts 'Creating generator'
generator = Reports::ReportGenerator.new(
  input: sources[0],
  output_directory: output_directory
)
puts 'Running report generator'
generator.generate_report
