# frozen_string_literal: true

require_relative 'report'

class InstitutionsReport < Report
  SUBREPORTS = %i[
    list_of_questions
    institution_profiles
  ].freeze

  def self.subreports
    SUBREPORTS
  end

  def generate_report
    SUBREPORTS.each do |subreport|
      log("Generating #{subreport} subreport")
      send("generate_#{subreport}")
    rescue NoMethodError
    end
  end

  private

  def generate_list_of_questions
    content = @data.headers.map.with_index do |header, index|
      "#{index + 1}. #{header}\n"
    end
    @persistor.save_subreport(
      type: :list_of_questions,
      content: content
    )
  end

  def generate_institution_profiles
    questions = @data.headers[1..11]
    institutions = []
    @data.by_row.each do |row|
      institution = {}
      questions.each do |question|
        institution[question] = row[question]
      end
      institutions << institution
    end
    @persistor.save_subreport(
      type: :institution_profiles,
      content: institutions
    )
  end

  def parse_input
    @data = CSV.parse(File.read(@input_file_path), headers: true)
  end
end
