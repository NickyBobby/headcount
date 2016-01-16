require "test_helper"
require "headcount_analyst"

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    @dr.load_data({
      enrollment: {
        kindergarten: "./data/Kindergartners in full-day program.csv",
        high_school_graduation: "./data/High school graduation rates.csv"
      }
    })
  end

  def test_can_get_both_districts
    ha = HeadcountAnalyst.new(dr)
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

  def test_returns_rate_of_kindergarten_participation_versus_high_school_graduation_rate
    ha = HeadcountAnalyst.new(dr)

    assert_equal 0.641, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
  end

  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_within_the_same_district
    ha = HeadcountAnalyst.new(dr)

    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")
  end

  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_across_the_state
    ha = HeadcountAnalyst.new(dr)

    assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "STATEWIDE")
  end
end
