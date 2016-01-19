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

def lunch_data
  [{ :district=>"Colorado",
     :time_frame=>"2000",
     :data_format=>"Percent",
     :data=>"0.07",
     :poverty_level=>"Eligible for Reduced Price Lunch" },
   { :district=>"Colorado",
     :time_frame=>"2000",
     :data_format=>"Percent",
     :data=>"0.27",
     :poverty_level=>"Eligible for Free or Reduced Lunch" },
   { :district=>"Colorado",
     :time_frame=>"2000",
     :data_format=>"Percent",
     :data=>"0.2",
     :poverty_level=>"Eligible for Free Lunch" }]
end

def economic_profile_data
  {
  :economic_profile => {
    :median_household_income => "./data/Median household income.csv",
    :children_in_poverty => "./data/School-aged children in poverty.csv",
    :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
    :title_i => "./data/Title I students.csv"
  }
}
end
