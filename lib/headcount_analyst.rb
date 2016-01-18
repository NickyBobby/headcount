require_relative "district_repository"

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

  private

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
