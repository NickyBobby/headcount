require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def parse_file(data)
    CSV.open data[:enrollment][:kindergarten],
                      headers: true,
                      header_converters: :symbol
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

  def connect_year_by_participation(participation, year)
    { year => participation }
  end

  def enrollment_exists(district)
    enrollments.detect { |enrollment| enrollment.name == district.upcase }
  end

  def create_enrollment(district, participation_by_year)
    enrollment = enrollment_exists(district)
    unless enrollment.nil?
      enrollment.participation.merge!(participation_by_year)
    else
      enrollments << Enrollment.new({
        name: district,
        kindergarten_participation: participation_by_year
      })
    end
  end

  def extract_info(contents)
    contents.each do |row|
      district = row[:district]
      year = row[:time_frame].to_i
      participation = row[:data].to_f.round(3)
      participation_by_year = connect_year_by_participation(participation, year)
      create_enrollment(district, participation_by_year)
    end
  end

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    extract_info(contents)
  end

  def find_by_name(district)
    enrollments.detect do |enrollment|
      enrollment.name.upcase.include?(district.upcase)
    end
  end
end

# if __FILE__ == $0
#   er = EnrollmentRepository.new
#   er.load_data({
#     :enrollment => {
#       :kindergarten => "./test/sample_kindergarten.csv"
#     }
#   })
#   p er.enrollments
#   enrollment = er.find_by_name("ACADEMY 20")
#   p enrollment
#   enron = er.find_by_name("NOOOOOO")
#   p enron
# end
