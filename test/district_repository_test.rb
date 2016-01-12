require "district_repository"

class DistrictRepositoryTest < Minitest::Test
  def test_can_create_instances
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end
end
