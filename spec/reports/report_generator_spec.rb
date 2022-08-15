# frozen_string_literal: true

require_relative '../../initialize'

RSpec.describe Reports::ReportGenerator do
  let(:generator) { described_class }

  describe '#initialize' do
    context 'when given a path for an existing file and an output directory' do
      it 'returns an instance of itself' do
        input_file_path = "#{PROJECT_DIRECTORY}/data/instytucje.csv"
        output_directory = 'outputdir'
        expect(generator.new(input: input_file_path,
                             output_directory: output_directory).is_a?(described_class)).to be(true)
      end
    end
    context 'when given a path for an existing file but no output directory' do
      it 'returns an instance of itself' do
        input_file_path = "#{PROJECT_DIRECTORY}/data/instytucje.csv"
        expect(generator.new(input: input_file_path).is_a?(described_class)).to be(true)
      end
    end

    context 'when given a path to a file that does not exist' do
      it 'raises Reports::ReportGenerator::InputFileNotFound' do
        non_existing_file = "#{PROJECT_DIRECTORY}/data/no_such.csv"
        expect { generator.new(input: non_existing_file) }.to raise_error(Reports::ReportGenerator::InputFileNotFound)
      end
    end
  end
end
