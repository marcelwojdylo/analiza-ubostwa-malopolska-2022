# frozen_string_literal: true

require_relative 'report'

class InstitutionsReport < Report
  SUBREPORT_TYPES = %i[
    lista_pytan
    badane_instytucje
    rodzaje_instytucji
    glowne_obszary_dzialania_instytucji
    adresy_email_ankietowanych
    definicja_ubostwa
    stosowane_kryteria_dochodowe
    proporcja_ubogich_wsrod_odbiorcow_instytucji
    dominujace_przyczyny_ubostwa
    dominujące_potrzeby_wynikające_z_ubóstwa
  ].freeze

  def self.subreport_types
    SUBREPORT_TYPES
  end

  def generate_report
    SUBREPORT_TYPES.each do |subreport_type|
      log("Generating #{subreport_type} subreport")
      method_name = "generate_#{subreport_type}"
      send(method_name)
    end
    persist_subreports
  end

  private

  def generate_stosowane_kryteria_dochodowe
    unique_answers = @data.by_col[13].map do |answer| 
      if (answer.downcase.include? "nie") || 
         (answer.downcase.include? "brak") || 
         (answer.include? "-") ||
         (answer.include? "jak wyżej")
        "nie stosujemy"
      else
        answer 
      end
    end
    add_subreport(
      type: :stosowane_kryteria_dochodowe,
      content: count_unique_answers(unique_answers)
    )
  end

  def generate_dominujące_potrzeby_wynikające_z_ubóstwa
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[16])
    add_subreport(
      type: :dominujące_potrzeby_wynikające_z_ubóstwa,
      content: count_unique_answers(unique_answers)
    )
  end

  def generate_proporcja_ubogich_wsrod_odbiorcow_instytucji
    add_subreport(
      type: :proporcja_ubogich_wsrod_odbiorcow_instytucji,
      content: count_unique_answers(@data.by_col[14])
    )
  end

  def generate_dominujace_przyczyny_ubostwa
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[15])
    add_subreport(
      type: :dominujace_przyczyny_ubostwa,
      content: count_unique_answers(unique_answers)
    )
  end

  def generate_definicja_ubostwa
    add_subreport(
      type: :definicja_ubostwa,
      content: count_unique_answers(@data.by_col[12])
    )
  end

  def generate_adresy_email_ankietowanych
    add_subreport(
      type: :adresy_email_ankietowanych,
      content: @data.by_col[1].map { |email| "#{email}," }
    )
  end

  def generate_glowne_obszary_dzialania_instytucji
    content = count_unique_answers(@data.by_col[9])
    add_subreport(
      type: :glowne_obszary_dzialania_instytucji,
      content: content
    )
  end

  def generate_rodzaje_instytucji
    content = count_unique_answers(@data.by_col[11])
    add_subreport(
      type: :rodzaje_instytucji,
      content: content
    )
  end

  def generate_lista_pytan
    content = @data.headers.map.with_index do |header, index|
      "#{index + 1}. #{header}\n"
    end
    add_subreport(
      type: :lista_pytan,
      content: content
    )
  end
  
  def generate_badane_instytucje
    questions = @data.headers[1..11]
    institutions = []
    @data.by_row.each do |row|
      institution = {}
      questions.each do |question|
        institution[question] = row[question]
      end
      institutions << institution
    end
    add_subreport(
      type: :badane_instytucje,
      content: institutions
    )
  end

  def parse_input
    @data = CSV.parse(File.read(@input_file_path), headers: true)
  end
end
