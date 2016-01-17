require 'pry'
require 'csv'
require_relative 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
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
          time_frame:  row[:timeframe],
          data_format: row[:dataformat],
          data:        row[:data]
        }
      end
      contents[grade] = hashes
    end
  end

  def connect_year_by_participation(participation, year)
    { year => participation }
  end

  def enrollment_exists(district)
    enrollments.detect { |enrollment| enrollment.name == district.upcase }
  end

  def merge_participation_by_year(enrollment, grade, participation_by_year)
    if enrollment.participation[grade].nil?
      enrollment.participation[grade] = participation_by_year
    else
      enrollment.participation[grade].merge!(participation_by_year)
    end
  end

  def create_enrollment(district, grade, participation_by_year)
    enrollment = enrollment_exists(district)
    unless enrollment.nil?
      merge_participation_by_year(enrollment, grade, participation_by_year)
    else
      enrollments << Enrollment.new({ name: district,
        grade_participation: { grade => participation_by_year }
      })
    end
  end

  def extract_info(contents)
    contents.each do |grade, rows|
      rows.each do |row|
        district = row[:district]
        year = row[:time_frame].to_i
        participation = row[:data].to_f.round(3)
        participation_by_year = connect_year_by_participation(participation, year)
        create_enrollment(district, grade, participation_by_year)
      end
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
#       :kindergarten => "./test/sample_kindergarten.csv",
#       :high_school_graduation => "./test/sample_high_school.csv"
#     }
#   })
#   p er.enrollments
#   enrollment = er.find_by_name("ACADEMY 20")
#   p enrollment
#   enron = er.find_by_name("NOOOOOO")
#   p enron
# end
