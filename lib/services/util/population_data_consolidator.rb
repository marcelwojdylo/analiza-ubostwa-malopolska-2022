module Util
  class PopulationDataConsolidator
    def initialize(
        input = [
          'data/populacja/ciochon/tabele/',
          'data/populacja/maciejewska/tabele/',
          'data/populacja/andrzejewska',
          'data/populacja/dobrowolska',
          'data/populacja/jablonowska',
          'data/populacja/konieczna',
          'data/populacja/zebala',
          'data/populacja/malaszki',
        ],      
        output = 'data/populacja/consolidated/sources.csv'
      )
      # malaszki = 'data/populacja/malaszki'
      # malaszki_csvs = Dir[Filej.join(malaszki, '**/*.csv')].sort.flatten
      # @malaszki_tables = malaszki_csvs.map do |path|
      #   CSV.parse(File.read(path), headers: true)
      # end


      csv_paths = []
      @output = output
      input.each do |path|
        csv_paths << Dir[File.join(path, '**/*.csv')].sort
      end
      csv_paths = csv_paths.flatten
      @tables = csv_paths.map do |path|
        CSV.parse(File.read(path), headers: true)
      end

    end

    def run
      @headers = gather_headers
      @rows = [@headers]
      @tables.each do |table|
        researcher_first_name, researcher_last_name = table[0][0].split(" ")[0..1]
        subject_number = "#{researcher_first_name[0..2]}#{researcher_last_name[0..2]}#{table[0][1]}"
        output_row = [table[0][0], subject_number]
        table.each do |row|
          question_id = row[2]
          next if question_id.nil?
          answer_id = row[3] || ''
          comment = row[4] || ''
          descriptive_answer = row[5] || ''
          @headers[2..-1].each do |header|
            header = header.downcase
            if header.include? question_id.downcase
              if header.include? 'numer odp.'
                output_row << answer_id
              elsif header.include? 'komentarz'
                output_row << comment
              elsif header.include? 'odp. opis.'
                output_row << descriptive_answer
              end
            else
              ''
            end
          end
        end
        @rows << output_row
      end
      # add_malaszki_to_rows
      CSV.open(@output, "w+") do |output_file|
        @rows.each { |row| output_file << row }
      end
      log "Done"
    end

    # def add_malaszki_to_rows
    #   @malaszki_tables.each do |table|
    #     last_subject_number = ''
    #     table.each do |row|
    #       researcher_first_name, researcher_last_name = row[0].split(" ")[0..1]
    #       subject_number = "#{researcher_first_name[0..2]}#{researcher_last_name[0..2]}#{row[1]}"
          
    #       output_row = [row[0], subject_number]
    #       last_subject_number = subject_number
    #     end
    #   end
    # end

    def gather_headers
      log "Gathering headers"
      [] + gather_questions
    end

    def gather_questions
      log "Gathering question ids"
      questions = []
      @tables.each do |table|
        table.each do |row|
          questions << row[2]
        end
      end
      questions = sort_question_ids(questions.uniq.compact)
      headers = ["Badacz", 'Respondent']
      questions.each do |question|
        headers << "#{question} numer odp."
        headers << "#{question} komentarz"
        headers << "#{question} odp. opis."
      end
      headers
    end

    def sort_question_ids(ids)
      comparables = ids.map do |id|
          if id.include? "A"
            id.gsub('A', '').to_f
          elsif id.include? "B"
            id.gsub('B', '.5').to_f
          else
            id.to_f
          end
      end.sort.map do |id|
        string = id.to_s
        if string.include? '.0'
          string.gsub('.0', '')
        elsif string.include? '.5'
          string.gsub('.5', 'B')
        end
      end
      result = comparables.map.with_index do |id, index|
        nexxt = comparables[index+1]
        if nexxt.nil?
          id
        elsif nexxt.include? 'B'
          id + "A"
        else
          id
        end
      end
    end
  end
end


# CSV.open(output, "w+") do |output_file|
#   first_input_file = CSV.parse(File.read(csv_paths[0]), headers: false)
#   headers = ["Respondent", "Badacz"]
#   first_input_file[1..].each do |row|
#     next unless row[2].present?
    
#     headers << "#{row[2]} numer odp."
#     headers << "#{row[2]} komentarz"
#     headers << "#{row[2]} odp. opis."
#   end
#   output_file << headers
#   csv_paths.each do |path|
#     data = CSV.parse(File.read(path), headers: false)
#     datapoint_id = data[1][1]
#     researcher_id = data[1][0]
#     row_for_output = [datapoint_id, researcher_id]
#     data[1..].each do |row|
#       row_for_output << row[3]
#       row_for_output << row[4]
#       row_for_output << row[5]
#     end
#     output_file << row_for_output
#   end
# end