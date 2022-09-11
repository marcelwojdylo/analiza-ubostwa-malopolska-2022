module Reports
  module CommonOperations
    def count_unique_answers(answers)
      content = answers.group_by{|e| e}.map{|k, v| [k, "#{(v.length.to_f/answers.length)*100}% (#{v.length})"]}.to_h
      content["Liczba wszystkich odpowiedzi: "] = answers.count
      return content
    end
  end
end