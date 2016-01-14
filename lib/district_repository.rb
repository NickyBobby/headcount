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

  def create_districts(locations)
    locations.each do |location|
      @districts << District.new(name: location)
    end
  end

  def parse_file(data)
    # maybe have its own class called Parser? Instance would be
    # used like parser.parse(data)
    CSV.open data[:enrollment][:kindergarten],
                     headers: true,
                     header_converters: :symbol
  end

  def get_locations(contents)
    contents.map do |row|
      row[:district]
    end.uniq
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

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    locations = get_locations(contents)
    create_districts(locations)
  end

  def find_by_name(district_name)
    districts.detect do |district|
      district.name == district_name.upcase
    end
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.name.include? fragment.upcase
    end
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
