$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pry'
require 'csv'
require 'enrollment'

class EnrollmentRepository
  attr_reader :enrollments

  def initialize
    @enrollments = []
  end

  def parse_file(enrollment_data)
    CSV.open enrollment_data[:enrollment][:kindergarten],
                      headers: true,
                      header_converters: :symbol
  end

  def load_data(enrollment_data)
    csv_contents = parse_file(enrollment_data)
    extract_info(contents)
  end

  def create_enrollment(district, participation_by_year)
    enrollment = enrollment_exists(district)
    unless enrollment.nil?
      enrollment.participation.merge!(participation_by_year)
    else
      enrollments << Enrollment.new({name: district,
                                    kindergarten_participation: participation_by_year})
    end
  end

  def extract_info(contents)
    contents.each do |row|
      district = row[:location]
      year = row[:timeframe].to_i
      participation = row[:data].to_f.round(3)
      participation_by_year = years_hash(participation, year)
      create_enrollment(district, participation_by_year)
    end
  end

  def enrollment_exists(district)
    enrollments.detect do |enrollment|
      enrollment.name == district
    end
  end


  def years_hash(participation, year)
    { year => participation }
  end

  def find_by_name(district)
    name = enrollments.detect do |enrollment|
      enrollment.name.upcase.include?(district.upcase)
    end
  end

end

er = EnrollmentRepository.new
er.load_data({
  :enrollment => {
    :kindergarten => "./data/sample_kindergarten.csv"
  }
})
p er.enrollments
# enrollment = er.find_by_name("ACADEMY 20")
# p enrollment
# enron = er.find_by_name("NOOOOOO")
# p enron
