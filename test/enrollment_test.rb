require "test_helper"
require "enrollment"

class EnrollmentTest < Minitest::Test
  def test_can_take_a_hash_with_a_name_key
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_equal "ACADEMY 20", e.name
  end

  def test_upcases_the_name_upon_creation
    e = Enrollment.new(name: "academy 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_equal "ACADEMY 20", e.name
  end

  def test_can_be_created_with_data_from_a_single_grade
    e = Enrollment.new(name: "ACADEMY 20",
                       kindergarten_participation: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       })
    assert e.participation.has_key? :kindergarten
    refute e.participation.has_key? :high_school_graduation
  end

  def test_can_be_create_with_data_from_multiple_grades
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: {
                         kindergarten: {
                           2010 => 0.3915,
                           2011 => 0.35356,
                           2012 => 0.2677
                         },
                         high_school_graduation: {
                           2010 => 0.895,
                           2011 => 0.895,
                           2012 => 0.88983
                         }
                       })
    assert e.participation.has_key? :kindergarten
    assert e.participation.has_key? :high_school_graduation
  end

  def test_sanitizes_participation_of_one_grade
    e = Enrollment.new(name: "ACADEMY 20",
                       kindergarten_participation: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       })

    assert_equal e.kindergarten_participation_in_year(2010), 0.392
  end

  def test_sanitizes_participation_of_multiple_grades
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: {
                         kindergarten: {
                           2010 => 0.3915,
                           2011 => 0.35356,
                           2012 => 0.2677
                         },
                         high_school_graduation: {
                           2010 => 0.895,
                           2011 => 0.895,
                           2012 => 0.88983
                         }
                       })
    assert_equal e.kindergarten_participation_in_year(2010), 0.392
    assert_equal e.graduation_rate_in_year(2012), 0.89
  end

  def test_will_return_list_of_kindergarten_participation_by_year
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    expected = { 2010 => 0.392, 2011 => 0.354, 2012 => 0.268 }
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

  def test_will_return_nill_if_participation_of_specific_year_does_not_exist
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    assert_nil e.kindergarten_participation_in_year(1999)
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

  def test_excludes_average_participation_for_a_year_if_not_present_in_both
    e1 = Enrollment.new(name: "ACADEMY 20",
                        grade_participation: { kindergarten: {
                          2009 => 0.222,
                          2010 => 0.43628,
                          2011 => 0.489,
                          2012 => 0.47883
                        }})
    e2 = Enrollment.new(name: "COLORADO",
                         grade_participation: { kindergarten: {
                           2010 => 0.64019,
                           2011 => 0.672,
                           2012 => 0.695,
                           2013 => 0.999
                         }})
    trend = e1.get_participation_average_by_year(e2)
    expected = { 2010 => 0.681, 2011 => 0.728, 2012 => 0.689 }
    assert_equal expected, trend
  end

  def test_get_average_participation_by_year_rounds_to_three_decimal_values
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

  def test_returns_high_school_graduation_rate_by_year
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { high_school_graduation: {
                         2010 => 0.895,
                         2011 => 0.895,
                         2012 => 0.88983
                       }})
    expected = { 2010 => 0.895, 2011 => 0.895, 2012 => 0.89 }
    assert_equal expected, e.graduation_rate_by_year
  end

  def test_will_return_graduation_rate_of_specific_year
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { high_school_graduation: {
                         2010 => 0.895,
                         2011 => 0.895,
                         2012 => 0.88983
                       }})
    assert_equal 0.895, e.graduation_rate_in_year(2010)
  end

  def test_will_return_nil_if_graduation_rate_of_specific_year_does_not_exist
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { high_school_graduation: {
                         2010 => 0.895,
                         2011 => 0.895,
                         2012 => 0.88983
                       }})
    assert_equal nil, e.graduation_rate_in_year(2016)
  end

  def test_returns_graduation_average
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { high_school_graduation: {
                         2010 => 0.895,
                         2011 => 0.895,
                         2012 => 0.88983
                       }})
    assert_equal 0.893, e.get_graduation_average
  end
end
