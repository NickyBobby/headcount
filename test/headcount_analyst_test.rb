require "test_helper"
require "headcount_analyst"

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new

  end

  def test_can_create_an_instance
    ha = HeadcountAnalyst.new(dr)

    assert_instance_of HeadcountAnalyst, ha
  end

  def test_can_get_kindergarten_participation_against_state_average
    ha = HeadcountAnalyst.new(dr)
    rate = ha.kindergarten_participation_rate_variation('ACADEMY 20', against: 'COLORADO')

    assert_equal 0.766, rate
  end

  def test_can_get_both_districts
    ha = HeadcountAnalyst.new(dr)
    ha.load_district_repo_data
    districts = ha.grab_districts('ACADEMY 20', 'COLORADO')

    assert_instance_of District, districts.first
    assert_equal 'ACADEMY 20', districts.first.name
    assert_instance_of District, districts.last
    assert_equal 'COLORADO', districts.last.name
  end
end
