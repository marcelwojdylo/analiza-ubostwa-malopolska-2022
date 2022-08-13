# frozen_string_literal: true

require_relative 'initialize'

sources = [
  'data/instytucje.csv'
]

output_directory = 'output'

generator = Reports::ReportGenerator.new(
  input: sources[0],
  output_directory: output_directory
)
generator.generate_report
