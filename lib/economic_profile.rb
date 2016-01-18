require "pry"
require_relative "unknown_data_error"

class EconomicProfile
  attr_reader :name, :median_household_income, :children_in_poverty,
              :free_or_reduced_price_lunch, :title_i

  def initialize(data)
    @name = data[:name].upcase
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end

  def median_household_income_in_year(year)
    raise_for_unknown_year(year, median_household_income.keys)
    incomes = []
    median_household_income.each_key do |range|
      next unless year.between?(range.first, range.last)
      incomes << median_household_income[range]
    end
    incomes.inject(0, :+) / incomes.count
  end

  private

    def raise_for_unknown_year(year, ranges)
      exists = ranges.any? do |range|
        year.between?(range.first, range.last)
      end
      raise UnknownDataError unless exists
    end
end
