require_relative "district"
require_relative "enrollment_repository"
require_relative "statewide_test_repository"
require_relative "economic_profile_repository"

class DistrictRepository
  attr_reader :districts, :er, :str, :epr

  def initialize
    @districts = []
    @er  = EnrollmentRepository.new
    @str = StatewideTestRepository.new
    @epr = EconomicProfileRepository.new
  end

  def create_districts(locations)
    locations.each do |location|
      create_district(location)
    end
  end

  def load_data(data)
    load_relationships(data)
    create_districts(locations)
  end

  def find_by_name(name)
    districts.detect { |district| district.name == name.upcase }
  end

  def find_all_by_name(names)
    names.map { |name| find_by_name(name) }
  end

  def find_all_matching(fragment)
    districts.select { |district| district.name.include? fragment.upcase }
  end

  private

    def create_district(location)
      district = District.new(name: location)
      create_relationships(district)
      @districts << district
    end

    def create_relationships(district)
      district.enrollment       = er.enrollment_exists(district.name)
      district.statewide_test   = str.statewide_test_exists(district.name)
      district.economic_profile = epr.economic_profile_exists(district.name)
    end

    def load_economic_profile(data)
      unless data[:economic_profile].nil?
        epr.load_data({ economic_profile: data[:economic_profile] })
      end
    end

    def load_enrollment(data)
      unless data[:enrollment].nil?
        er.load_data({ enrollment: data[:enrollment] })
      end
    end

    def load_relationships(data)
      load_enrollment(data)
      load_statewide_testing(data)
      load_economic_profile(data)
    end

    def load_statewide_testing(data)
      unless data[:statewide_testing].nil?
        str.load_data({ statewide_testing: data[:statewide_testing] })
      end
    end

    def locations
      er.enrollments.map(&:name)
    end
end
