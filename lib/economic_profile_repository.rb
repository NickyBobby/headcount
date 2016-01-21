require_relative "economic_profile"
require_relative "normalize"
require_relative "parser"

class EconomicProfileRepository
  attr_accessor :economic_profiles
  attr_reader :normalize, :parser

  def initialize
    @economic_profiles = []
    @normalize         = Normalize.new
    @parser            = Parser.new
  end

  def economic_profile_exists(name)
    economic_profiles.detect { |ep| ep.name == name.upcase }
  end

  def load_data(data)
    csv_contents = parser.parse_files(data)
    contents = convert_to_hashes(csv_contents)
    lunch = contents[:free_or_reduced_price_lunch]
    contents[:free_or_reduced_price_lunch] = normalize.normalize_lunch(lunch)
    poverty = contents[:children_in_poverty]
    contents[:children_in_poverty] = normalize.normalize_poverty(poverty)
    extract_contents(contents)
  end

  def find_by_name(name)
    economic_profiles.detect { |ep| ep.name == name.upcase }
  end

  private

    def convert_to_hashes(contents)
      contents.each do |profile, csv|
        data = csv.map do |row|
          data_template(row)
        end
        contents[profile] = data
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

    def data_template(row)
      single_data = {
        district:    row[:location],
        time_frame:  row[:timeframe],
        data_format: row[:dataformat],
        data:        row[:data]
      }
      single_data[:poverty_level] = row[:poverty_level] if row[:poverty_level]
      single_data
    end

    def extract_contents(contents)
      contents.each do |ep, rows|
        rows.each do |row|
          data = normalize.normalize_economic_data_for_creation(ep, row)
          create_economic_profile(data)
        end
      end
    end

    def merge_economic_profile(ep, data)
      symbol = data.keys.first
      unless data.keys.first == :free_or_reduced_price_lunch
        ep.send(symbol).merge!(data[symbol])
      else
        merge_free_or_reduced_price_lunch(ep, data)
      end
    end

    def merge_free_or_reduced_price_lunch(ep, data)
      year = data[:free_or_reduced_price_lunch].keys.first
      if ep.free_or_reduced_price_lunch[year]
        ep.free_or_reduced_price_lunch[year]
                        .merge!(data[:free_or_reduced_price_lunch][year])
      else
        ep.free_or_reduced_price_lunch.merge!(data[:free_or_reduced_price_lunch])
      end
    end
end
