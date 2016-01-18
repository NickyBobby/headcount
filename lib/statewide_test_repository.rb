require "pry"
require "csv"
require_relative "statewide_test"

class StatewideTestRepository
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = []
  end

  def statewide_test_exists(district)
    statewide_tests.detect { |st| st.name == district.upcase }
  end

  def parse_file(data)
    data.values.each_with_object({}) do  |subjects, obj|
      subjects.each do |subject, file|
        csv = CSV.open file, headers: true, header_converters: :symbol
        obj[subject] = csv
      end
    end
  end

  def normalize_subject(subject)
    if subject == "Hawaiian/Pacific Islander"
      subject.split("/").last.gsub(/\s/, "_").downcase.to_sym
    else
      subject.gsub!(/\s/, "_")
      subject.downcase.to_sym
    end
  end

  def convert_csv_to_hashes(contents)
    contents.each do |subject, csv|
      data = csv.map do |row|
        {
          district:    row[:location],
          subject:     normalize_subject(row[:score] || row[:race_ethnicity]),
          time_frame:  row[:timeframe],
          data_format: row[:dataformat],
          data:        row[:data]
        }
      end
      contents[subject] = data
    end
  end

  def connect_year_by_proficiency(year, participation)
    { year => participation }
  end

  def statewide_test_exists(district_name)
    statewide_tests.detect { |st| st.name == district_name.upcase }
  end

  def merge_proficiency_by_year(statewide_test, proficiency_by_year, data)
    if statewide_test.subjects[data[:grade]]
      if statewide_test.subjects[data[:grade]][data[:subject]]
        statewide_test.subjects[data[:grade]][data[:subject]].merge!(proficiency_by_year)
      else
        statewide_test.subjects[data[:grade]].merge!(data[:subject] => proficiency_by_year)
      end
    else
      subject = { data[:subject] => proficiency_by_year }
      statewide_test.subjects[data[:grade]] = subject
    end
  end

  def create_statewide_test(proficiency_by_year, data)
    statewide_test = statewide_test_exists(data[:district])
    unless statewide_test.nil?
      merge_proficiency_by_year(statewide_test, proficiency_by_year, data)
    else
      statewide_tests << StatewideTest.new({
        name: data[:district],
        subject: { data[:grade] => { data[:subject] => proficiency_by_year } }
      })
    end
  end

  # def create_enrollment(district, grade, participation_by_year)
  #   enrollment = enrollment_exists(district)
  #   unless enrollment.nil?
  #     merge_participation_by_year(enrollment, grade, participation_by_year)
  #   else
  #     enrollments << Enrollment.new({ name: district,
  #       grade_participation: { grade => participation_by_year }
  #     })
  #   end
  # end

  def extract_contents(contents)
    contents.each do |grade, rows|
      rows.each do |row|
        data = {}
        data[:grade] = grade
        data[:district] = row[:district]
        data[:year] = row[:time_frame].to_i
        data[:proficiency] = row[:data].to_f.round(3)
        data[:subject] = row[:subject]
        proficiency_by_year = connect_year_by_proficiency(data[:year], data[:proficiency])
        create_statewide_test(proficiency_by_year, data)
      end
    end
  end

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    extract_contents(contents)
  end

  def find_by_name(statewide_test_name)
    statewide_tests.detect do |statewide_test|
      statewide_test.name.upcase.include?(statewide_test_name.upcase)
    end
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
  binding.pry
end
