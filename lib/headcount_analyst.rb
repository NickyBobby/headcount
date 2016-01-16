require_relative "district_repository"

class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end

  def grab_districts(district1, district2)
    dr.find_all_by_name([district1, district2])
  end

  def kindergarten_participation_rate_variation(district, compared_district)
    districts = grab_districts(district, compared_district[:against])
    d1_average = districts.first.enrollment.get_participation_average
    d2_average = districts.last.enrollment.get_participation_average
    (d1_average / d2_average).round(3)
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
    (d1_average / d2_average).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    k_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    hs_variation = high_school_graduation_rate_variation(district, :against => "COLORADO")
    (k_variation / hs_variation).round(3)
  end

end
