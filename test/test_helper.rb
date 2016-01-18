require "minitest"
require 'simplecov'
SimpleCov.start

def economic_data
  {
    :median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "academy 20"
  }
end
