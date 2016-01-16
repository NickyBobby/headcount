require "test_helper"
require "enrollment"

class EnrollmentTest < Minitest::Test

  def test_can_be_instantiated_on
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_instance_of Enrollment, e
  end

  def test_can_take_an_argument_with_a_name_in_it
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_equal "ACADEMY 20", e.name
  end

  def test_will_return_list_of_kindergarten_participation_by_year
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    expected = { 2010 => 0.392, 2011 => 0.354, 2012 => 0.268 }

    assert_instance_of Enrollment, e
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_will_return_participation_of_specific_year
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_equal 0.392, e.kindergarten_participation_in_year(2010)
  end

  def test_sanitizes_participation
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    sanitized = e.sanitize({ kindergarten: { 2010 => 0.3915 } })
    expected = { 2010 => 0.392 }

    assert_equal expected, sanitized[:kindergarten]
  end

  def test_gets_average_participation_for_all_years
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    average = e.get_participation_average

    assert_equal 0.338, average
  end

  def test_get_average_participation_by_year
    e1 = Enrollment.new(name: "ACADEMY 20",
                        grade_participation: { kindergarten: {
                          2010 => 0.43628,
                          2011 => 0.489,
                          2012 => 0.47883
                        }})
    e2 = Enrollment.new(name: "COLORADO",
                         grade_participation: { kindergarten: {
                           2010 => 0.64019,
                           2011 => 0.672,
                           2012 => 0.695
                         }})
    trend = e1.get_participation_average_by_year(e2)
    expected = { 2010 => 0.681, 2011 => 0.728, 2012 => 0.689 }

    assert_equal expected, trend
  end
end
