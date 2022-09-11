module Reports
  module CommonOperations
    def count_unique_answers(answers)
      content = answers.map(&:strip).group_by{|e| e}.map{|k, v| [k, "#{(v.length.to_f/answers.length)*100}% (#{v.length})"]}.to_h
      content["Liczba wszystkich odpowiedzi: "] = answers.count
      return content
    end

    def clean_up_checkbox_answers(rows)
      rows = rows.map { |a| a.gsub("Nie, poziom", "nie — poziom") }
      rows = rows.map { |a| a.gsub("(alkohol, narkotyki)", "(alkohol lub narkotyki)")}
      rows = rows.map { |a| a.gsub("czynsz, media, podatki", "czynsz media podatki")}
      rows = rows.map { |a| a.gsub("wakacyjne, feryjne", "wakacyjne feryjne")}
      rows = rows.map { |a| a.gsub("środki higieniczne i odzież", "środki higieniczne, odzież")}
      rows = rows.map { |a| a.gsub(", w któr", " w któr")}
      rows = rows.map { |a| a.gsub(", któr", " któr")}
      rows = rows.map { |a| a.gsub(", gdzie", " gdzie")}
      rows = rows.map { |a| a.gsub("zdrowie, w sz", "zdrowie a w sz")}
      
      rows = rows.map { |a| a.gsub(",,", ",")}
      rows.reject { |a| a == 'brak' }
    end

    def clean_up_dunnos(rows)
      rows.map do |row|
        row = row.downcase.strip
        dunnos = [
          "nie mam wiedzy", 
          "brak informacji", 
          "nie wiemy",
          "nie wiem",
          "jak wyżej",
          "brak wiedzy w tym obszarze",
          "nie dotyczy",
          "nie dotyczy.",
          "nie znamy odpowiedzi"
        ]
        if dunnos.include? row
          "trudno powiedzieć"
        else
          row
        end
      end
    end

    def unique_answers_from_checkbox_rows(rows)
      rows = clean_up_checkbox_answers(rows)
      unique_answers = []
      rows.each do |answer|
        unique_answers << answer.downcase.split(', ')
      end
      unique_answers.flatten.uniq
    end
  end
end