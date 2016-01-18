require "pry"

class EconomicProfileRepository
  attr_reader :parser

  def initialize
    @economic_profiles = []
  end

  def load_data(data)
    csv_contents = CSVParser.parse_files(epr_data)
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
