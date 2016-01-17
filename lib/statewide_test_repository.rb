require "pry"
require "csv"


class StatewideTestRepository



  def parse_file(data)
    data.values.each_with_object({}) do  |grades, obj|
      grades.each do |grade, file|
        csv = CSV.open file, headers: true, header_converters: :symbol
        obj[grade] = csv
      end
    end
  end

  def load_data(data)
    csv_contents = parse_file(data)
    binding.pry
  end

end

if __FILE__ == $0
  str = StatewideTestRepository.new
  str.load_data({
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })
  # str = str.find_by_name("ACADEMY 20")
  # => <StatewideTest>
end
