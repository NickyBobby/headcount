require "csv"

class Parser
  def parse_files(data)
    data.values.each_with_object({}) do  |subjects, obj|
      subjects.each do |subject, file|
        csv = CSV.open file, headers: true, header_converters: :symbol
        obj[subject] = csv
      end
    end
  end
end
