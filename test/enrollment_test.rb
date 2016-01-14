require "test_helper"
require "enrollment"

class EnrollmentTest < Minitest::Test

  def test_can_be_instantiated_on
    e = Enrollment.new({:name => "ACADEMY 20",
                        :kindergarten_participation => {
                          2010 => 0.3915,
                          2011 => 0.35356,
                          2012 => 0.2677
    }})
    assert_instance_of Enrollment, e
  end

  def test_can_take_an_argument_with_a_name_in_it
    e = Enrollment.new({:name => "Colorado",
                        :kindergarten_participation => {
                          2010 => 0.3915,
                          2011 => 0.35356,
                          2012 => 0.2677
    }})
    assert_equal "Colorado", e.name
  end

  def test_will_return_list_of_kindergarten_participation_by_year
    e = Enrollment.new({:name => "ACADEMY 20",
                        :kindergarten_participation => {
                          2010 => 0.3915,
                          2011 => 0.35356,
                          2012 => 0.2677
    }})
    expected = { 2010 => 0.392, 2011 => 0.354, 2012 => 0.268 }

    assert_instance_of Enrollment, e
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_will_return_participation_of_specific_year
    e = Enrollment.new({:name => "ACADEMY 20",
                        :kindergarten_participation => {
                          2010 => 0.3915,
                          2011 => 0.35356,
                          2012 => 0.2677
    }})
    assert_equal 0.392, e.kindergarten_participation_in_year(2010)
  end

  def test_sanitizes_participation
    e = Enrollment.new({:name => "ACADEMY 20",
                        :kindergarten_participation => {
                          2010 => 0.3915,
                          2011 => 0.35356,
                          2012 => 0.2677
    }})
    sanitized = e.sanitize({ 2010 => 0.3915 })
    expected = { 2010 => 0.392 }

    assert_equal expected, sanitized
  end
end
