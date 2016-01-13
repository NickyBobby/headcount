require "district_repository"

class DistrictRepositoryTest < Minitest::Test
  def test_can_create_instances
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_can_load_in_data_and_create_district_objects
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })

    assert_instance_of District, dr.districts[0]
  end

  def test_can_find_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_by_name("ASPEN 1")

    assert_instance_of District, d
    assert_equal "ASPEN 1", d.name
  end

  def test_can_find_district_by_name_with_case_insensitivity
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_by_name("aspen 1")

    assert_instance_of District, d
    assert_equal "ASPEN 1", d.name
  end

  def test_returns_nil_if_cant_find_district_by_name
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_by_name("lawls")

    assert d.nil?
  end

  def test_returns_an_array_of_all_districts_matching_a_fragment
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_all_matching("AD")

    assert_equal 4, d.count
    assert_equal 'COLORADO', d.first.name
    assert_equal 'ADAMS-ARAPAHOE 28J', d.last.name
  end
end
