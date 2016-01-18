require "csv"
require "pry"
require_relative "district"
require_relative "enrollment_repository"
require_relative "statewide_test_repository"

class DistrictRepository
  attr_reader :districts, :er, :str

  def initialize
    @districts = []
    @er  = EnrollmentRepository.new
    @str = StatewideTestRepository.new
  end

  def create_relationships(district)
    enrollment = er.enrollment_exists(district.name)
    st = str.statewide_test_exists(district.name)
    district.enrollment = enrollment
    district.statewide_test = st
  end

  def create_districts(locations)
    locations.each do |location|
      district = District.new(name: location)
      create_relationships(district)
      @districts << district
    end
  end

  def load_relationship_data(data)
    er.load_data({ enrollment: data[:enrollment] })
    return unless data[:statewide_testing]
    str.load_data({ statewide_testing: data[:statewide_testing] })
  end

  def get_locations
    er.enrollments.map(&:name)
  end

  def load_data(data)
    load_relationship_data(data)
    locations = get_locations
    create_districts(locations)
  end

  def find_by_name(district_name)
    districts.detect { |district| district.name == district_name.upcase }
  end

  def find_all_by_name(names)
    names.map { |name| find_by_name(name) }
  end

  def find_all_matching(fragment)
    districts.select { |district| district.name.include? fragment.upcase }
  end
end

if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv",
    },
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })
  district = dr.find_by_name("ACADEMY 20")
  statewide_test = district.statewide_test
  binding.pry
end
