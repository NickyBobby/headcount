require_relative "district_repository"
require_relative "insufficient_information_error"

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
    check_for_insufficient_information(data)
    if data[:subject].nil?
      districts = dr.districts.map do |district|
        growth = district.statewide_test.year_over_year_growth_all_subjects(data)
        [district.name, growth.round(3)]
      end
    else
      districts = dr.districts.map do |district|
        growth = district.statewide_test.year_over_year_growth(data[:grade], data[:subject], 1.0)
        [district.name, growth.round(3)]
      end
    end
    sorted_districts = districts.sort_by { |d| d.last }.reverse
    return sorted_districts.first unless data[:top]
    sorted_districts[0...data[:top]]
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


if __FILE__ == $0
  dr = DistrictRepository.new
  dr.load_data({
    enrollment: {
      kindergarten: "./data/Kindergartners in full-day program.csv",
      high_school_graduation: "./data/High school graduation rates.csv"
    },
    statewide_testing: {
      third_grade: "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      eighth_grade: "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      math: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      reading: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      writing: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })
  ha = HeadcountAnalyst.new(dr)
  p ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
end
