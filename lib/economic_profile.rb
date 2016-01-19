require "pry"
require_relative "unknown_data_error"
require_relative "normalize"

class EconomicProfile
  attr_accessor :free_or_reduced_price_lunch
  attr_reader :name, :median_household_income, :children_in_poverty,
              :title_i, :normalize

  def initialize(data)
    @name = data[:name].upcase
    @median_household_income     = data[:median_household_income] || {}
    @children_in_poverty         = data[:children_in_poverty] || {}
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch] || {}
    @title_i                     = data[:title_i] || {}
    @normalize                   = Normalize.new
  end

  def median_household_income_in_year(year)
    raise_for_unknown_year_in_ranges(year, median_household_income.keys)
    incomes = []
    median_household_income.each_key do |range|
      next unless year.between?(range.first, range.last)
      incomes << median_household_income[range]
    end
    incomes.inject(0, :+) / incomes.count
  end

  def median_household_income_average
    median_household_income.values.inject(0, :+) / median_household_income.count
  end

  def children_in_poverty_in_year(year)
    raise_for_unknown_year(year, children_in_poverty.keys)
    normalize.number(children_in_poverty[year])
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise_for_unknown_year(year, free_or_reduced_price_lunch.keys)
    normalize.number(free_or_reduced_price_lunch[year][:percentage])
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise_for_unknown_year(year, free_or_reduced_price_lunch.keys)
    normalize.number(free_or_reduced_price_lunch[year][:total])
  end

  def title_i_in_year(year)
    raise_for_unknown_year(year, title_i.keys)
    normalize.number(title_i[year])
  end

  private

    def raise_for_unknown_year_in_ranges(year, ranges)
      exists = ranges.any? { |range| year.between?(range.first, range.last) }
      raise UnknownDataError unless exists
    end

    def raise_for_unknown_year(year, years)
      exists = years.any? { |existing_year| existing_year == year }
      raise UnknownDataError unless exists
    end
end
