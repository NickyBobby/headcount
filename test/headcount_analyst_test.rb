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
      },
      statewide_testing: {
        third_grade: "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        eighth_grade: "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        math: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        reading: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        writing: "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
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

    assert_equal 0.642, ha.kindergarten_participation_against_high_school_graduation("ACADEMY 20")
  end

  def test_can_predict_correlation_of_kindergarten_participation_and_high_school_graduation_within_the_same_district
    ha = HeadcountAnalyst.new(dr)

    assert_equal true, ha.kindergarten_participation_correlates_with_high_school_graduation(for: "ACADEMY 20")
  end

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

  def test_raises_unknown_data_error_when_wrong_grade_is_entered
    ha = HeadcountAnalyst.new(dr)
    assert_raises UnknownDataError do
      ha.top_statewide_test_year_over_year_growth(grade: 9)
    end
  end

  def test_returns_statewide_test_year_over_year_growth_top_district_for_all_subjects
    ha = HeadcountAnalyst.new(dr)
    d = ha.top_statewide_test_year_over_year_growth(grade: 3)
    assert_equal ["SANGRE DE CRISTO RE-22J", 0.071], d
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

  def test_returns_statewide_test_year_over_year_growth_top_district_for_weighted_subjects
    ha = HeadcountAnalyst.new(dr)
    d = ha.top_statewide_test_year_over_year_growth(grade: 3, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
    assert_equal ["WILEY RE-13 JT", 0.119], d
  end
end
