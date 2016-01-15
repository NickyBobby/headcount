require "csv"
require "pry"
require_relative "district"
require_relative "enrollment_repository"

class DistrictRepository
  attr_reader :districts, :er

  def initialize
    @districts = []
    @er = EnrollmentRepository.new
  end

  def create_relationship(district)
    enrollment = er.enrollment_exists(district.name)
    district.enrollment = enrollment
  end

  def create_districts(locations)
    locations.each do |location|
      district = District.new(name: location)
      create_relationship(district)
      @districts << district
    end
  end

  def load_enrollment_data(data)
    er.load_data(data)
  end

  def get_locations
    er.enrollments.map(&:name)
  end

  def load_data(data)
    load_enrollment_data(data)
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

# if __FILE__ == $0
#   dr = DistrictRepository.new
#   dr.load_data({
#     enrollment: {
#       kindergarten: "./data/Kindergartners in full-day program.csv"
#     }
#   })
#   p dr.find_by_name "ACADEMY 20"
#   p dr.find_by_name "Doesn't Exist"
#   p dr.find_all_matching "AD"
#   p dr.find_all_matching "%"
# end
