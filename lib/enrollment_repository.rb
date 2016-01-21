require_relative "enrollment"
require_relative "parser"

class EnrollmentRepository
  attr_reader :enrollments, :parser

  def initialize
    @enrollments = []
    @parser = Parser.new
  end

  def connect_year_by_participation(participation, year)
    { year => participation }
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

  def enrollment_exists(district)
    enrollments.detect { |enrollment| enrollment.name == district.upcase }
  end

  def extract_info(contents)
    contents.each do |grade, rows|
      rows.each do |row|
        prepare_data_for_creation(row, grade)
      end
    end
  end

  def load_data(data)
    csv_contents = parser.parse_files(data)
    contents = convert_csv_to_hashes(csv_contents)
    extract_info(contents)
  end

  def find_by_name(district)
    enrollments.detect do |enrollment|
      enrollment.name.upcase.include?(district.upcase)
    end
  end

  private

    def convert_csv_to_hashes(contents)
      contents.each do |grade, csv|
        hashes = csv.map do |row|
          data_template(row)
        end
        contents[grade] = hashes
      end
    end

    def data_template(row)
      {
        district:    row[:location],
        time_frame:  row[:timeframe],
        data_format: row[:dataformat],
        data:        row[:data]
      }
    end

    def merge_participation_by_year(enrollment, grade, participation_by_year)
      if enrollment.participation[grade].nil?
        enrollment.participation[grade] = participation_by_year
      else
        enrollment.participation[grade].merge!(participation_by_year)
      end
    end

    def prepare_data_for_creation(row, grade)
      district = row[:district]
      year = row[:time_frame].to_i
      participation = row[:data].to_f.round(3)
      year_participation = connect_year_by_participation(participation, year)
      create_enrollment(district, grade, year_participation)
    end
end
