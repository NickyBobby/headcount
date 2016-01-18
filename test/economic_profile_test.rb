require "test_helper"
require "economic_profile"

class EconomicProfileTest < Minitest::Test
  def test_takes_in_data_when_created
    ep = EconomicProfile.new(economic_data)
    assert_equal "ACADEMY 20", ep.name
    assert_equal economic_data[:median_household_income], ep.median_household_income
    assert_equal economic_data[:children_in_poverty], ep.children_in_poverty
    assert_equal economic_data[:free_or_reduced_price_lunch], ep.free_or_reduced_price_lunch
    assert_equal economic_data[:title_i], ep.title_i
  end

  def test_upcases_name_when_created
    ep = EconomicProfile.new(economic_data)
    assert_equal "ACADEMY 20", ep.name
  end

  def test_returns_median_household_income_in_year
    ep = EconomicProfile.new(economic_data)
    assert_equal 50000, ep.median_household_income_in_year(2005)
    assert_equal 55000, ep.median_household_income_in_year(2009)
  end

  def test_raises_unknown_data_error_for_unknown_year_in_range
    ep = EconomicProfile.new(economic_data)
    assert_raises UnknownDataError do
      ep.median_household_income_in_year(1999)
    end
  end

  def test_returns_median_household_income
    ep = EconomicProfile.new(economic_data)
    assert_equal 55000, ep.median_household_income_average
  end

  def test_returns_children_in_poverty_in_year
    ep = EconomicProfile.new(economic_data)
    assert_equal 0.185, ep.children_in_poverty_in_year(2012)
  end

  def test_returns_free_or_reduced_price_lunch_percentage_in_year
    ep = EconomicProfile.new(economic_data)
    assert_equal 0.023, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_raises_unknown_data_error_for_unknown_year
    ep = EconomicProfile.new(economic_data)
    assert_raises UnknownDataError do
      ep.children_in_poverty_in_year(1999)
    end
    assert_raises UnknownDataError do
      ep.free_or_reduced_price_lunch_percentage_in_year(1999)
    end
  end
end
