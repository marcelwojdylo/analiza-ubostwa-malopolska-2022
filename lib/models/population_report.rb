require_relative 'report'

class PopulationReport < Report
  
  SUBREPORTS = [
    :list_of_questions
  ]

  def type
    :population_report
  end
end