require "test_helper"
require "district"
require "enrollment"
require "statewide_test"

class DistrictTest < Minitest::Test
  def test_can_take_a_hash_with_a_name_key
    d = District.new(name: "ACADEMY 20")
    assert_equal "ACADEMY 20", d.name
  end

  def test_upcases_the_name_upon_creation
    d = District.new(name: "academy 20")
    assert_equal "ACADEMY 20", d.name
  end

  def test_has_an_enrollment_that_starts_off_nil
    d = District.new(name: "ACADEMY 20")
    assert_nil d.enrollment
  end

  def test_can_assign_enrollment_to_enrollment_attribute
    d = District.new(name: "ACADEMY 20")
    e = Enrollment.new(name: "ACADEMY 20",
                       grade_participation: { kindergarten: {
                         2010 => 0.3915,
                         2011 => 0.35356,
                         2012 => 0.2677
                       }})
    d.enrollment = e
    assert_equal e, d.enrollment
  end

  def test_has_an_statewide_test_that_starts_off_nil
    d = District.new(name: "ACADEMY 20")
    assert_nil d.statewide_test
  end

  def test_can_assign_statewide_test_to_statewide_test_attribute
    d = District.new(name: "ACADEMY 20")
    st = StatewideTest.new(statewide_test_data)
    d.statewide_test = st
    assert_equal st, d.statewide_test
  end

  def test_has_an_economic_profile_that_starts_off_nil
    d = District.new(name: "ACADEMY 20")
    assert_nil d.economic_profile
  end

  def test_can_assign_economic_profile_to_economic_profile_attribute
    d = District.new(name: "ACADEMY 20")
    ep = EconomicProfile.new(economic_profile_data)
    d.economic_profile = ep
    assert_equal ep, d.economic_profile
  end
end
