require "test_helper"
require "normalize"

class NormalizeTest < Minitest::Test
  def test_normalizes_a_float_to_three_decimal_points
    normalize = Normalize.new
    assert_equal 0.346, normalize.number(0.3456)
    assert_equal 0.249, normalize.number(0.249)
    assert_equal 0.77,  normalize.number(0.77)
    assert_equal 0.1,   normalize.number(0.1)
    assert_equal 1.0,   normalize.number(1)
  end

  def test_normalizes_economic_profile_repo_lunches
    normalize = Normalize.new
    expected = [{
      district: "Colorado",
      time_frame: "2000",
      data_format: "Percent",
      data: "0.27",
      poverty_level: "Eligible for Free or Reduced Lunch"
    }]
    assert_equal expected, normalize.normalize_lunch(lunch_data)
  end
end
