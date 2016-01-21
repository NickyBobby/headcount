require "pry"
require "csv"
require_relative "economic_profile"
require_relative "normalize"

class EconomicProfileRepository
  attr_accessor :economic_profiles
  attr_reader :normalize

  def initialize
    @economic_profiles = []
    @normalize = Normalize.new
  end

  def parse_file(data)
    data.values.each_with_object({}) do  |subjects, obj|
      subjects.each do |subject, file|
        csv = CSV.open file, headers: true, header_converters: :symbol
        obj[subject] = csv
      end
    end
  end

  def convert_csv_to_hashes(contents)
    contents.each do |profile, csv|
      data = csv.map do |row|
        single_data = {
          district:    row[:location],
          time_frame:  row[:timeframe],
          data_format: row[:dataformat],
          data:        row[:data]
        }
        single_data[:poverty_level] = row[:poverty_level] if row[:poverty_level]
        single_data
      end
      contents[profile] = data
    end
  end

  def economic_profile_exists(name)
    economic_profiles.detect { |ep| ep.name == name.upcase }
  end

  def merge_economic_profile(economic_profile, data)
    symbol = data.keys.first
    unless data.keys.first == :free_or_reduced_price_lunch
      economic_profile.send(symbol).merge!(data[symbol])
    else
      year = data[:free_or_reduced_price_lunch].keys.first
      if economic_profile.free_or_reduced_price_lunch[year]
        economic_profile.free_or_reduced_price_lunch[year]
                        .merge!(data[:free_or_reduced_price_lunch][year])
      else
        economic_profile.free_or_reduced_price_lunch.merge!(data[:free_or_reduced_price_lunch])
      end
    end
  end

  def create_economic_profile(data)
    economic_profile = economic_profile_exists(data[:name])
    unless economic_profile.nil?
      merge_economic_profile(economic_profile, data)
    else
      economic_profiles << EconomicProfile.new(data)
    end
  end

  def extract_contents(contents)
    contents.each do |ep, rows|
      rows.each do |row|
        data = normalize.normalize_economic_data_for_creation(ep, row)
        create_economic_profile(data)
      end
    end
  end

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    lunch_data = contents[:free_or_reduced_price_lunch]
    contents[:free_or_reduced_price_lunch] = normalize.normalize_lunch(lunch_data)
    poverty = contents[:children_in_poverty]
    contents[:children_in_poverty] = normalize.normalize_poverty(poverty)
    extract_contents(contents)
  end

  def find_by_name(name)
    economic_profiles.detect { |ep| ep.name == name.upcase }
  end
end

# if __FILE__ == $0
#   epr = EconomicProfileRepository.new
#   epr.load_data({
#     economic_profile: {
#       median_household_income: "./data/Median household income.csv",
#       children_in_poverty: "./data/School-aged children in poverty.csv",
#       free_or_reduced_price_lunch: "./data/Students qualifying for free or reduced price lunch.csv",
#       title_i: "./data/Title I students.csv"
#     }
#   })
# end
