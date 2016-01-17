require "test_helper"
require "sanitizer"

class SanitizerTest < Minitest::Test
  def test_can_sanitize_a_hash_of_participations_to_three_decimal_values
    data = { 2010 => 0.3688, 2011 => 0.4567 }
    Sanitizer.sanitize(data)
    assert_equal 0.369, data[2010]
    assert_equal 0.457, data[2011]
  end

  def test_sanitize_raises_an_argument_error_if_not_given_a_hash
    data = [0.3688, 0.4567]
    assert_raises ArgumentError do
      Sanitizer.sanitize(data)
    end
  end

  def test_can_sanitize_multiple_grades_with_participation
    participation = {
      kindergarten: { 2010 => 0.2345, 2011 => 0.9876 },
      high_school_graduation: { 2010 => 0.12345, 2011 => 0.3456 }
    }
    Sanitizer.sanitize_grades(participation)
    assert_equal 0.235, participation[:kindergarten][2010]
    assert_equal 0.346, participation[:high_school_graduation][2011]
  end

  def test_sanitize_grades_raises_an_argument_error_if_not_given_a_hash
    data = [0.3688, 0.4567]
    assert_raises ArgumentError do
      Sanitizer.sanitize_grades(data)
    end
  end
end
