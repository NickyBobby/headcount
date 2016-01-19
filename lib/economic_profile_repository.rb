require "pry"
require "csv"
require_relative "normalize"

class EconomicProfileRepository
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

  def load_data(data)
    csv_contents = parse_file(data)
    contents = convert_csv_to_hashes(csv_contents)
    lunch_data = contents[:free_or_reduced_price_lunch]
    contents[:free_or_reduced_price_lunch] = normalize.normalize_lunch(lunch_data)
    binding.pry
  end
end

if __FILE__ == $0
  epr = EconomicProfileRepository.new
  epr.load_data({
    economic_profile: {
      median_household_income: "./data/Median household income.csv",
      children_in_poverty: "./data/School-aged children in poverty.csv",
      free_or_reduced_price_lunch: "./data/Students qualifying for free or reduced price lunch.csv",
      title_i: "./data/Title I students.csv"
    }
  })
end
