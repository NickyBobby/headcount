require_relative "district_repository"

class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
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
    if districts.member?(:for)
      if districts[:for] == 'STATEWIDE'
        true_or_false = dr.districts.map do |district|
          variance = kindergarten_participation_against_high_school_graduation(district.name)
          variance.between?(0.6, 1.5)
        end
        total = true_or_false.count
        true_count = true_or_false.count { |bool| bool == true }
        true_count / total >= 0.7
      else
        variance = kindergarten_participation_against_high_school_graduation(districts[:for])
        variance.between?(0.6, 1.5)
      end
    end
  end

end
