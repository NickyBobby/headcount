require "test_helper"
require "sanitizer"

class SanitizerTest < Minitest::Test
  def test_can_sanitize_a_hash_of_participations_to_three_decimal_values
    data = { 2010 => 0.3688, 2011 => 0.4567 }
    Sanitizer.sanitize(data)
    assert_equal 0.369, data[2010]
    assert_equal 0.457, data[2011]
  end
end
