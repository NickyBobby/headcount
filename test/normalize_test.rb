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
end
