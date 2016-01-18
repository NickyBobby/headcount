class EconomicProfile
  attr_reader :name, :median_household_income, :children_in_poverty,
              :free_or_reduced_price_lunch, :title_i

  def initialize(data)
    @name = data[:name]
    @median_household_income     = data[:median_household_income]
    @children_in_poverty         = data[:children_in_poverty]
    @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
    @title_i                     = data[:title_i]
  end
end
