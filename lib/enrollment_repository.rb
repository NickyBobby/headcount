require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def parse_file(data)
    kindergarten_data = CSV.open data[:enrollment][:kindergarten],
                      headers: true,
                      header_converters: :symbol
    highschool_data = CSV.open data[:enrollment][:high_school_graduation],
                      headers: true,
                      header_converters: :symbol
    { kindergarten_data: kindergarten_data, highschool_data: highschool_data }
  end

  def convert_csv_to_hashes(contents)
    contents.map do |row|
      {
        district:    row[:location],
        time_frame:  row[:timeframe],
        data_format: row[:dataformat],
        data:        row[:data]
      }
    end
  end

  def connect_year_by_rate(rate, year)
    { year => rate }
  end

  def enrollment_exists(district)
    enrollments.detect { |enrollment| enrollment.name == district.upcase }
  end

  def create_enrollment(district, participation_by_year, high_school_graduation)
    enrollment = enrollment_exists(district)
    unless enrollment.nil?
      enrollment.participation.merge!(participation_by_year)
    else
      enrollments << Enrollment.new({
        name: district,
        kindergarten_participation: participation_by_year,
        high_school_graduation: high_school_graduation
      })
    end
  end

  def create_enrollments(contents)
    contents.each do |row|
      district = row[:district]
      year = row[:time_frame].to_i
      participation = row[:data].to_f.round(3)
      participation_by_year = connect_year_with_rate(participation, year)
      graduation_by_year = connect_year_with_rate(graduation, year)
      create_enrollment(district, participation_by_year, high_school_graduation)
    end
  end

  def load_data(data)
    csvs_contents = parse_file(data)
    # binding.pry
    districts_participations = participations_by_year(csvs_contents[:kindergarten_data])
      # {"COLORADO" => {}
      # "ABC" => {participation_data}}
    districts_graduations = graduations_by_year(csvs_contents[:highschool_data])
    # contents = convert_csv_to_hashes(csvs_contents[:kindergarten_data])
    create_enrollments(contents)
  end

  def find_by_name(district)
    enrollments.detect do |enrollment|
      enrollment.name.upcase.include?(district.upcase)
    end
  end
end

if __FILE__ == $0
  er = EnrollmentRepository.new
  er.load_data({
    :enrollment => {
      :kindergarten => "./test/sample_kindergarten.csv",
      :high_school_graduation => "./test/sample_high_school_graduation.csv"
    }
  })
  p er.enrollments
  # enrollment = er.find_by_name("ACADEMY 20")
  # p enrollment
  # enron = er.find_by_name("NOOOOOO")
  # p enron
end
