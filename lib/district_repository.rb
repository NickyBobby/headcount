$LOAD_PATH.unshift(File.dirname(__FILE__))
require "district"
require "csv"
require "pry"

class DistrictRepository
  attr_reader :districts

  def initialize
    @districts = []
  end

  def create_districts(districts)
    districts.each do |district|
      @districts << District.new(name: district)
    end
  end

  def parse_file(options)
    CSV.open options[:enrollment][:kindergarten],
                     headers: true,
                     header_converters: :symbol
  end

  def load_data(options)
    contents = parse_file(options)
    districts = contents.map do |row|
      row[:location]
    end.uniq
    create_districts(districts)
  end

  def find_by_name(district_name)
    district_name.upcase!
    districts.select do |district|
      district.name == district_name
    end.first
  end
end

if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data({
    enrollment: {
      kindergarten: "./data/Kindergartners in full-day program.csv"
    }
  })
end
