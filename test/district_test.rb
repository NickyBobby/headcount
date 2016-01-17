require "test_helper"
require "district"

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
end
