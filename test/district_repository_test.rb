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
end
