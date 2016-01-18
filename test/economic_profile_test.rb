require "test_helper"
require "economic_profile"

class EconomicProfileTest < Minitest::Test
  def test_takes_in_data_when_created
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
            :children_in_poverty => {2012 => 0.1845},
            :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
            :title_i => {2015 => 0.543},
            :name => "ACADEMY 20"
    }
    ep = EconomicProfile.new(data)
    assert_equal "ACADEMY 20", ep.name
    assert_equal data[:median_household_income], ep.median_household_income
    assert_equal data[:children_in_poverty], ep.children_in_poverty
    assert_equal data[:free_or_reduced_price_lunch], ep.free_or_reduced_price_lunch
    assert_equal data[:title_i], ep.title_i
  end
end
