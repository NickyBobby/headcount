require_relative "statewide_test"
require_relative "parser"

class StatewideTestRepository
  attr_reader :statewide_tests, :parser

  def initialize
    @statewide_tests = []
    @parser = Parser.new
  end

  def statewide_test_exists(district)
    statewide_tests.detect { |st| st.name == district.upcase }
  end

  def normalize_subject(subject)
    if subject == "Hawaiian/Pacific Islander"
      subject.split("/").last.gsub(/\s/, "_").downcase.to_sym
    else
      subject.gsub!(/\s/, "_")
      subject.downcase.to_sym
    end
  end

  def data_template(row)
    {
      district:    row[:location],
      subject:     normalize_subject(row[:score] || row[:race_ethnicity]),
      time_frame:  row[:timeframe],
      data_format: row[:dataformat],
      data:        row[:data]
    }
  end

  def convert_csv_to_hashes(contents)
    contents.each do |subject, csv|
      data = csv.map do |row|
        data_template(row)
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

  def merge_by_subject(state_test, proficiency, data)
    if state_test.subjects[data[:grade]][data[:subject]]
      state_test.subjects[data[:grade]][data[:subject]].merge!(proficiency)
    else
      state_test.subjects[data[:grade]].merge!(data[:subject] => proficiency)
    end
  end

  def merge_proficiency_by_year(state_test, proficiency, data)
    if state_test.subjects[data[:grade]]
      merge_by_subject(state_test, proficiency, data)
    else
      subject = { data[:subject] => proficiency }
      state_test.subjects[data[:grade]] = subject
    end
  end

  def add_statewide_test_to_repository(proficiency_by_year, data)
    statewide_tests << StatewideTest.new({
      name: data[:district],
      subject: { data[:grade] => { data[:subject] => proficiency_by_year } }
    })
  end

  def create_statewide_test(proficiency_by_year, data)
    state_test = statewide_test_exists(data[:district])
    unless state_test.nil?
      merge_proficiency_by_year(state_test, proficiency_by_year, data)
    else
      add_statewide_test_to_repository(proficiency_by_year, data)
    end
  end

  def prepare_data_for_creation(row, grade)
    data = {}
    data[:grade] = grade
    data[:district] = row[:district]
    data[:year] = row[:time_frame].to_i
    data[:proficiency] = row[:data].to_f.round(3)
    data[:subject] = row[:subject]
    proficiency_by_year = connect_year_by_proficiency(data[:year], data[:proficiency])
    create_statewide_test(proficiency_by_year, data)
  end

  def extract_contents(contents)
    contents.each do |grade, rows|
      rows.each do |row|
        prepare_data_for_creation(row, grade)
      end
    end
  end

  def load_data(data)
    csv_contents = parser.parse_files(data)
    contents = convert_csv_to_hashes(csv_contents)
    extract_contents(contents)
  end

  def find_by_name(statewide_test_name)
    statewide_tests.detect do |statewide_test|
      statewide_test.name.upcase.include?(statewide_test_name.upcase)
    end
  end
end
