require_relative 'report'

class PopulationReport < Report
  
  SUBREPORTS = [
    :list_of_questions
  ]

  def generate
  end

  def type
    :population_report
  end

  def parse_input
  end
end