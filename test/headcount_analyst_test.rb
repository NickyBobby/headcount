require "test_helper"
require "headcount_analyst"

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    @dr.load_data(headcount_analyst_files)
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

  def test_can_get_kindergarten_participation_trend_against_state_average
    ha = HeadcountAnalyst.new(dr)
    trend = ha.kindergarten_participation_rate_variation_trend("ACADEMY 20",
                                                               against: "COLORADO")
    assert_instance_of Hash, trend
    refute trend[2010].nil?
  end

  def test_returns_rate_of_kindergarten_participation_versus_high_school_graduation_rate
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.642, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
  end

  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_within_the_same_district
    ha = HeadcountAnalyst.new(dr)
    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")
  end
  meta t: true
  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_across_the_state
    ha = HeadcountAnalyst.new(dr)
    assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "STATEWIDE")
  end

  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_across_different_districts
    ha = HeadcountAnalyst.new(dr)
    assert_equal false, ha.kindergarten_participation_correlates_with_high_school_graduation(across: ["ACADEMY 20", "CHERRY CREEK 5"])
  end

  def test_valid_grade_must_be_provided
    ha = HeadcountAnalyst.new(dr)
    assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_returns_statewide_test_year_over_year_growth_top_district
    ha = HeadcountAnalyst.new(dr)
    d = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)
    assert_equal ["WILEY RE-13 JT", 0.3], d
  end

  def test_returns_statewide_test_year_over_year_growth_for_top_three_districts
    ha = HeadcountAnalyst.new(dr)
    d = ha.top_statewide_test_year_over_year_growth(grade: 3, top: 3, subject: :math)
    expected = [["WILEY RE-13 JT", 0.3], ["SANGRE DE CRISTO RE-22J", 0.072], ["COTOPAXI RE-3", 0.07]]
    assert_equal expected, d
  end

  def test_returns_growth_across_all_three_subjects
    ha = HeadcountAnalyst.new(dr)
    result = ha.top_statewide_test_year_over_year_growth(grade: 3)
    expected = ["SANGRE DE CRISTO RE-22J", 0.071]
    assert_equal expected, result
  end

  def test_returns_growth_across_all_three_subjects_weighted
    ha = HeadcountAnalyst.new(dr)
    result = ha.top_statewide_test_year_over_year_growth(grade: 3,
      weighting: { math: 0.5, reading: 0.5, writing: 0.0 }
    )
    expected = ["WILEY RE-13 JT", 0.119]
    assert_equal expected, result
  end
end
