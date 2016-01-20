require "minitest"
require 'simplecov'
SimpleCov.start

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

def economic_profile_files
  {
    economic_profile: {
      median_household_income: "./test/median_household_income_test.csv",
      children_in_poverty: "./test/school_aged_children_in_poverty_test.csv",
      free_or_reduced_price_lunch: "./test/students_qualifying_for_free_or_reduced_price_lunch_test.csv",
      title_i: "./test/title_i_students_test.csv"
    }
  }
end

def enrollment_file
  {
    enrollment: {
      kindergarten: "./test/sample_kindergarten.csv"
    }
  }
end

def statewide_file
end

def enrollment_statewide_files
  {
    enrollment: {
      kindergarten: "./test/sample_kindergarten.csv"
    },
    statewide_testing: {
      third_grade: "./test/sample_third_grade.csv"
    }
  }
end

def load_all_files
  {
    enrollment: {
      kindergarten: "./test/sample_kindergarten.csv"
    },
    statewide_testing: {
      third_grade: "./test/sample_third_grade.csv"
    },
    economic_profile: {
      :children_in_poverty => "./data/School-aged children in poverty.csv",
      :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv"
    }
  }
end

def statewide_test_data
  { name: "ACADEMY 20", subject: {
         third_grade: {
           math:    { 2008 => 0.8578, 2009 => 0.8246 },
           reading: { 2008 => 0.8662, 2009 => 0.8623 },
           writing: { 2008 => 0.6714, 2009 => 0.7063 }
         }
       }
     }
end


def economic_profile_data
  {
    :median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
    :children_in_poverty => {2012 => 0.1845},
    :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
    :title_i => {2015 => 0.543},
    :name => "academy 20"
  }
end
