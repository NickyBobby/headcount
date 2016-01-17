require "pry"
require "csv"
require_relative "statewide_test"


class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = []
  end

  def parse_file(data)
    data.values.each_with_object({}) do  |grades, obj|
      grades.each do |grade, file|
        csv = CSV.open file, headers: true, header_converters: :symbol
        obj[grade] = csv
      end
    end
  end

  def convert_csv_to_hashes(contents)
    contents.each do |grade, csv|
      hashes = csv.map do |row|
        {
          district:    row[:location],
          subject:       row[:score],
          time_frame:  row[:timeframe],
          data_format: row[:dataformat],
          data:        row[:data]
        }
      end
      contents[grade] = hashes
    end
  end

  def connect_year_with_rate(participation, year)
    { year => participation }
  end

  def statewide_test_exists?(district)
    statewide_tests.detect { |s_test| s_test.name == district.upcase }
  end

  def merge_rate_by_year(statewide_test, subject, rate_by_year)
    # binding.pry
    if statewide_test.subject[subject].nil?
      statewide_test.subject[subject] = rate_by_year
    else
      statewide_test.subject[subject].merge!(rate_by_year)
    end
  end

  def create_statewide_test(district, subject, rate_by_year)
    statewide_test = statewide_test_exists?(district)
    unless statewide_test.nil?
      merge_rate_by_year(statewide_test, subject, rate_by_year)
    else
      statewide_tests << StatewideTest.new({ name: district,
        subject: { subject => rate_by_year }
      })
    end
  end

  def extract_info(contents)
    contents.each do |grade, rows|
      rows.each do |row|
        district = row[:district]
        subject = row[:subject]
        year = row[:time_frame].to_i
        rate = row[:data].to_f.round(3)
        rate_by_year = connect_year_with_rate(rate, year)
        create_statewide_test(district, subject, rate_by_year)
      end
    end
  end

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    extract_info(contents)
  end

end

# if __FILE__ == $0
#   str = StatewideTestRepository.new
#   str.load_data({
#     :statewide_testing => {
#       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
#       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
#       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
#       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
#       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
#     }
#   })
#   str = str.find_by_name("ACADEMY 20")
#   => <StatewideTest>
# end
