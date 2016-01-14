require_relative "district_repository"

class HeadcountAnalyst
  attr_reader :dr

  def initialize(district_repo)
    @dr = district_repo
  end
  # this can go... hopefull, run spec harness
  def load_district_repo_data
    dr.load_data({
      enrollment: {
        kindergarten: "./data/Kindergartners in full-day program.csv"
      }
    })
  end

  def grab_districts(district1, district2)
    dr.find_all_by_name([district1, district2])
  end

  def kindergarten_participation_rate_variation(district, compared_district)
    # ask Josh about how we are loading data. If before we pass in dr or after
    load_district_repo_data
    districts = grab_districts(district, compared_district[:against])
    d1_average = districts.first.enrollment.get_participation_average
    d2_average = districts.last.enrollment.get_participation_average
    (d1_average / d2_average).round(3)
  end

  def kindergarten_participation_rate_variation_trend(district, compared_district)
    load_district_repo_data
    districts = grab_districts(district, compared_district[:against])
    e1 = districts.first.enrollment
    e2 = districts.last.enrollment
    e1.get_participation_average_by_year(e2)
  end
end
