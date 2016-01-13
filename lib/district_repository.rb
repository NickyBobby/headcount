$LOAD_PATH.unshift(File.dirname(__FILE__))
require "district"
require "csv"

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = []
  end

  def create_districts(locations)
    locations.each do |location|
      @districts << District.new(name: location)
    end
  end

  def parse_file(options)
    # maybe have its own class called Parser? Instance would be
    # used like parser.parse(options)
    CSV.open options[:enrollment][:kindergarten],
                     headers: true,
                     header_converters: :symbol
  end

  def get_locations(contents)
    contents.map do |row|
      row[:location]
    end.uniq
  end

  def load_data(options)
    contents = parse_file(options)
    locations = get_locations(contents)
    create_districts(locations)
  end

  def find_by_name(district_name)
    districts.select do |district|
      district.name == district_name.upcase
    end.first
  end

  def find_all_matching(fragment)
    districts.select do |district|
      district.name.include? fragment.upcase
    end
  end
end

if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data({
    enrollment: {
      kindergarten: "./data/Kindergartners in full-day program.csv"
    }
  })
  p dr.find_by_name "ACADEMY 20"
  p dr.find_by_name "Doesn't Exist"
  p dr.find_all_matching "AD"
  p dr.find_all_matching "%"
end
