require_relative "district_repository"
require_relative "headcount_errors"

class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end

  def kindergarten_participation_rate_variation(district, compared)
    districts = grab_districts(district, compared[:against])
    d1_average = districts.first.enrollment.get_participation_average
    d2_average = districts.last.enrollment.get_participation_average
    variation = (d1_average / d2_average).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_rate_variation_trend(district, compared)
    districts = grab_districts(district, compared[:against])
    e1 = districts.first.enrollment
    e2 = districts.last.enrollment
    e1.get_participation_average_by_year(e2)
  end

  def high_school_graduation_rate_variation(district, compared)
    districts = grab_districts(district, compared[:against])
    d1_average = districts.first.enrollment.get_graduation_average
    d2_average = districts.last.enrollment.get_graduation_average
    variation = (d1_average / d2_average).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    k = kindergarten_participation_rate_variation(district, against: "COLORADO")
    hs = high_school_graduation_rate_variation(district, against: "COLORADO")
    variation = (k / hs).round(3)
    check_for_nan(variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    if name[:for] == "STATEWIDE" || name[:across]
      districts = name[:across] || dr.districts.map(&:name)
      bools = participation_booleans(districts)
      above_seventy_percent?(bools)
    else
      v = kindergarten_participation_against_high_school_graduation(name[:for])
      within_range?(v)
    end
  end

  def create_growth_data_for_all_subjects(data)
    dr.districts.map do |d|
      growth = d.statewide_test.year_over_year_growth_all_subjects(data)
      [d.name, growth.round(3)]
    end
  end

  def create_growth_data_for_subject(data)
    dr.districts.map do |d|
      growth = d.statewide_test.year_over_year_growth(data[:grade],
                                                      data[:subject], 1.0)
      [d.name, growth.round(3)]
    end
  end

  def sort_districts(districts, data)
    sorted_districts = districts.sort_by { |d| d.last }.reverse
    return sorted_districts.first unless data[:top]
    sorted_districts[0...data[:top]]
  end

  def top_statewide_test_year_over_year_growth(data)
    check_for_insufficient_information(data)
    if data[:subject].nil?
      districts = create_growth_data_for_all_subjects(data)
    else
      districts = create_growth_data_for_subject(data)
    end
    sort_districts(districts, data)
  end

  private

    def check_for_insufficient_information(data)
      if data[:grade].nil?
        raise InsufficientInformationError,
              "A grade must be provided to answer this question"
      end
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
      districts.map do |name|
        v = kindergarten_participation_against_high_school_graduation(name)
        within_range?(v)
      end
    end

    def above_seventy_percent?(booleans)
      true_count = booleans.count { |bool| bool == true }
      true_count / booleans.count >= 0.7
    end
end
