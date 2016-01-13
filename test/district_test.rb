require "district"

class DistrictTest < Minitest::Test
  def test_can_create_instances
    d = District.new(name: "ACADEMY 20")

    assert_instance_of District, d
  end

  def test_can_take_a_hash_with_a_name_key
    d = District.new(name: "ACADEMY 20")

    assert_equal "ACADEMY 20", d.name
  end

  def test_upcases_the_name_upon_creation
    d = District.new(name: "academy 20")

    assert_equal "ACADEMY 20", d.name
  end
end
