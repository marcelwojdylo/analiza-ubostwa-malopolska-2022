require_relative 'report'

class InstitutionsReport < Report
  SUBREPORTS = [
      :list_of_questions
  ]

  def self.subreports
    SUBREPORTS
  end

  def generate_report
    SUBREPORTS.each do |subreport|
      puts("Generating #{subreport} subreport")
      self.send("generate_#{subreport}")
    rescue NoMethodError
    end
  end

  private

  def generate_list_of_questions
    content = @data.headers.map.with_index do |header, index|
      "#{ index + 1 }. #{header}\n"
    end
    @persistor.save_subreport(
      type: :list_of_questions,
      content: content
    )
  end
  

  def parse_input
    @data = CSV.parse(File.read(@input_file_path), headers: true)
  end
end