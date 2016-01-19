require_relative "district_repository"
require_relative "insufficient_information_error"
require_relative "unknown_data_error"
require 'pry'

class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end

  def kindergarten_participation_rate_variation(district, compared_district)
    districts = grab_districts(district, compared_district[:against])
    d1_average = districts.first.enrollment.get_participation_average
    d2_average = districts.last.enrollment.get_participation_average
    variation = (d1_average / d2_average).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_rate_variation_trend(district, compared_district)
    districts = grab_districts(district, compared_district[:against])
    e1 = districts.first.enrollment
    e2 = districts.last.enrollment
    e1.get_participation_average_by_year(e2)
  end

  def high_school_graduation_rate_variation(district, compared_district)
    districts = grab_districts(district, compared_district[:against])
    d1_average = districts.first.enrollment.get_graduation_average
    d2_average = districts.last.enrollment.get_graduation_average
    variation = (d1_average / d2_average).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    k_variation = kindergarten_participation_rate_variation(district, against: "COLORADO")
    hs_variation = high_school_graduation_rate_variation(district, against: "COLORADO")
    variation = (k_variation / hs_variation).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(districts)
    if districts[:for] == "STATEWIDE" || districts[:across]
      districts = districts[:across] || dr.districts
      bools = participation_booleans(districts)
      above_seventy_percent?(bools)
    else
      variance = kindergarten_participation_against_high_school_graduation(districts[:for])
      within_range?(variance)
    end
  end

  def top_statewide_test_year_over_year_growth(data)
    raise InsufficientInformationError unless data[:grade]
    raise UnknownDataError unless [3, 8].include? data[:grade]
    if data[:subject]
      grade = convert_to_grade_symbol[data[:grade]]
      subject = data[:subject]
      rate_differences = []
      dr.districts.each do |enrollment|
        district = enrollment.statewide_test.name
        subjects = enrollment.statewide_test.subjects[grade][subject]
        min, max = subjects.keys.minmax
        max_prof = subjects[max]
        min_prof = subjects[min]
        rate_diff = ((max_prof - min_prof)/(max - min)).round(3)
        rate_differences << [district, rate_diff]
      end
      if data[:top]
        top = data[:top]
        rate_differences.sort_by {|a| a.last}[-top..-1]
      else
        rate_differences.sort_by {|a| a.last}.last
      end
    else
      grade = convert_to_grade_symbol[data[:grade]]
      rate_differences = []
      dr.districts.each do |enrollment|
        subject_list.each do |subject|
          district = enrollment.statewide_test.name
          subjects = enrollment.statewide_test.subjects[grade][subject]
          min, max = subjects.keys.minmax
          max_prof = subjects[max]
          min_prof = subjects[min]
          rate_diff = ((max_prof - min_prof)/(max - min)).round(3)
          rate_differences << [district, subject, rate_diff]
        end
      end
      sum = 0
      sub_diffs = []
      rate_differences.each_slice(3) do |slice|
        district = slice.first[0]
        slice.each do |arr|
          sum += arr[2]
        end
        sub_diffs << [district, (sum/3).round(3)]
      end
      sub_diffs.sort_by {|a| a.last}.last
    end
  end

  private

    def subject_list
      [:math, :reading, :writing]
    end

    def convert_to_grade_symbol
      { 3 => :third_grade, 8 => :eighth_grade }
    end

    def grab_districts(district1, district2)
      dr.find_all_by_name([district1, district2])
    end

    def check_for_nan(number)
      if number.nan?
        0
      else
        number
      end
    end

    def within_range?(num)
      num.between?(0.6, 1.5)
    end

    def participation_booleans(districts)
      districts.map do |district_name|
        district_name = district_name.name if district_name.is_a? District
        variance = kindergarten_participation_against_high_school_graduation(district_name)
        within_range?(variance)
      end
    end

    def above_seventy_percent?(booleans)
      true_count = booleans.count { |bool| bool == true }
      true_count / booleans.count >= 0.7
    end
end

# ha.top_statewide_test_year_over_year_growth(subject: :math)
# ~> InsufficientInformationError: A grade must be provided to answer this question
#
# ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
# => ...some sort of result...
# ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
# => ...some sort of result...
# ha.top_statewide_test_year_over_year_growth(grade: 9, subject: :math)
# ~> UnknownDataError: 9 is not a known grade
