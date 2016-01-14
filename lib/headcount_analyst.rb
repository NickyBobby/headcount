require_relative "district_repository"

class HeadcountAnalyst
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def load_district_repo_data
    district_repo.load_data({
      enrollment: {
        kindergarten: "./data/Kindergartners in full-day program.csv"
      }
    })
  end

  def grab_districts(district, district_against)
    d1 = district_repo.find_by_name(district)
    d2 = district_repo.find_by_name(district_against)
    [d1, d2]
  end

  def kindergarten_participation_rate_variation(district, compared_district)
    load_district_repo_data
    districts = grab_districts(district, compared_district[:against])
    d1_average = districts.first.enrollment.get_participation_average
    d2_average = districts.last.enrollment.get_participation_average
    (d1_average / d2_average).round(3)
  end
end
