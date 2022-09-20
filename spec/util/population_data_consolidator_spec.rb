# frozen_string_literal: true

require_relative '../../initialize'

RSpec.describe Util::PopulationDataConsolidator do
  let(:consolidator) { described_class.new }
  describe '#gather_headers' do
    it 'returns an array' do
      headers = consolidator.gather_headers
      expect(headers).to be_a(Array)
    end
  end
  xdescribe '#gather_questions' do
    it 'returns an array' do
      questions = consolidator.gather_questions
      expect(questions).to be_a(Array)
    end
  end
end