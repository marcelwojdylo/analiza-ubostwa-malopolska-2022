require_relative 'report'

class InstitutionsReport < Report
  SUBREPORTS = [
      :list_of_questions
  ]

  def type
    :institutions_report
  end

  def parse_input
    @data = CSV.parse(File.read(@input_file_path), headers: true)
  end
end