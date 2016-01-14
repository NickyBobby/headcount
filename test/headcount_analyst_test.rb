require "test_helper"
require "headcount_analyst"

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    # load in data
  end

  def test_can_get_both_districts
    ha = HeadcountAnalyst.new(dr)
    ha.load_district_repo_data
    districts = ha.grab_districts("ACADEMY 20", "COLORADO")

    assert_equal ["ACADEMY 20", "COLORADO"], districts.map(&:name)
  end

  def test_can_get_kindergarten_participation_against_state_average
    ha = HeadcountAnalyst.new(dr)
    rate = ha.kindergarten_participation_rate_variation("ACADEMY 20",
                                                        against: "COLORADO")

    assert_equal 0.766, rate
  end

  def test_can_get_kindergarten_participation_against_another_district
    ha = HeadcountAnalyst.new(dr)
    rate = ha.kindergarten_participation_rate_variation("ACADEMY 20",
                                                        against: "YUMA SCHOOL DISTRICT 1")

    assert_equal 0.447, rate
  end

  def test_can_kindergarten_participation_trend_against_state_average
    ha = HeadcountAnalyst.new(dr)
    trend = ha.kindergarten_participation_rate_variation_trend("ACADEMY 20",
                                                               against: "COLORADO")

    assert_instance_of Hash, trend
    refute trend[2010].nil?
  end
end
