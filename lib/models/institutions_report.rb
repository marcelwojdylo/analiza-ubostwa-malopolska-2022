# frozen_string_literal: true

require_relative 'report'

class InstitutionsReport < Report
  SUBREPORT_TYPES = %i[
    lista_pytań
    badane_instytucje
    rodzaje_instytucji
    główne_obszary_działania_instytucji
    adresy_email_ankietowanych
    definicja_ubóstwa
    stosowane_kryteria_dochodowe
    proporcja_ubogich_wśród_odbiorcow_instytucji
    dominujące_przyczyny_ubóstwa
    dominujące_potrzeby_wynikające_z_ubóstwa
    rodzaje_wsparcia_oferowane_przez_instytucje
    percepcja_powszechności_ubóstwa_w_krakowie_u_instytucji
    szczególnie_ubogie_dzielnice_krakowa
    dzielnice_krakowa_o_wyższym_poziomie_ubóstwa
    grupy_społeczne_o_wyższym_poziomie_ubóstwa
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

  def generate_dzielnice_krakowa_o_wyższym_poziomie_ubóstwa
    answers = clean_up_dunnos(@data.by_col[20])
    answers = answers.map do |a| a.include?('nową') ? a.gsub('nową', 'nowa') : a end
    answers = answers.map do |a| a.include?('stare podgórze') ? 'podgórze' : a end
    unique_answers = answers.uniq.map do |answer|
      answer.split(', ')
    end.flatten
    add_subreport(
      type: :dzielnice_krakowa_o_wyższym_poziomie_ubóstwa,
      content: count_unique_answers(unique_answers),
      question: @data.headers[20]
    )
  end

  def generate_szczególnie_ubogie_dzielnice_krakowa
    add_subreport(
      type: :szczególnie_ubogie_dzielnice_krakowa,
      content: count_unique_answers(@data.by_col[19]),
      question: @data.headers[19]
    )
  end

  def generate_percepcja_powszechności_ubóstwa_w_krakowie_u_instytucji
    add_subreport(
      type: :percepcja_powszechności_ubóstwa_w_krakowie_u_instytucji,
      content: count_unique_answers(@data.by_col[18]),
      question: @data.headers[18]
    )
  end

  def generate_grupy_społeczne_o_wyższym_poziomie_ubóstwa
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[21])
    add_subreport(
      type: :grupy_społeczne_o_wyższym_poziomie_ubóstwa,
      content: count_unique_answers(unique_answers),
      question: @data.headers[21]
    )
  end

  def generate_rodzaje_wsparcia_oferowane_przez_instytucje
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[17])
    add_subreport(
      type: :rodzaje_wsparcia_oferowane_przez_instytucje,
      content: count_unique_answers(unique_answers),
      question: @data.headers[17]
    )
  end
  
  def generate_dominujące_potrzeby_wynikające_z_ubóstwa
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[16])
    add_subreport(
      type: :dominujące_potrzeby_wynikające_z_ubóstwa,
      content: count_unique_answers(unique_answers),
      question: @data.headers[16]
    )
  end

  def generate_proporcja_ubogich_wśród_odbiorcow_instytucji
    add_subreport(
      type: :proporcja_ubogich_wśród_odbiorcow_instytucji,
      content: count_unique_answers(@data.by_col[14]),
      question: @data.headers[14]
    )
  end

  def generate_dominujące_przyczyny_ubóstwa
    unique_answers = unique_answers_from_checkbox_rows(@data.by_col[15])
    add_subreport(
      type: :dominujące_przyczyny_ubóstwa,
      content: count_unique_answers(unique_answers),
      question: @data.headers[15]
    )
  end

  def generate_definicja_ubóstwa
    add_subreport(
      type: :definicja_ubóstwa,
      content: count_unique_answers(@data.by_col[12]),
      question: @data.headers[12]
    )
  end

  def generate_adresy_email_ankietowanych
    add_subreport(
      type: :adresy_email_ankietowanych,
      content: @data.by_col[1].map { |email| "#{email}," }
    )
  end

  def generate_główne_obszary_działania_instytucji
    content = count_unique_answers(@data.by_col[9])
    add_subreport(
      type: :główne_obszary_działania_instytucji,
      content: content,
      question: @data.headers[9]
    )
  end

  def generate_rodzaje_instytucji
    content = count_unique_answers(@data.by_col[11])
    add_subreport(
      type: :rodzaje_instytucji,
      content: content,
      question: @data.headers[11]
    )
  end

  def generate_lista_pytań
    content = @data.headers.map.with_index do |header, index|
      "#{index + 1}. #{header}\n"
    end
    add_subreport(type: :lista_pytań,
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
