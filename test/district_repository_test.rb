require "test_helper"
require "district_repository"

class DistrictRepositoryTest < Minitest::Test
  def test_starts_off_with_empty_districts
    dr = DistrictRepository.new
    assert_equal [], dr.districts
  end

  def test_has_enrollment_repository_upon_creation
    dr = DistrictRepository.new
    assert_instance_of EnrollmentRepository, dr.er
  end

  def test_has_statewide_test_repository_upon_creation
    dr = DistrictRepository.new
    assert_instance_of StatewideTestRepository, dr.str
  end

  def test_has_economic_profile_repository_upon_creation
    dr = DistrictRepository.new
    assert_instance_of EconomicProfileRepository, dr.epr
  end

  def test_can_load_in_data_and_create_district_objects
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/sample_kindergarten.csv"
      }
    })
    dr.districts.each do |district|
      assert_instance_of District, district
    end
  end

  def test_can_manually_create_districts
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    assert_equal "ASPEN 1", dr.districts.first.name
  end

  def test_can_find_district_by_name
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    d = dr.find_by_name("ASPEN 1")
    assert_equal "ASPEN 1", d.name
  end

  def test_can_find_district_by_name_with_case_insensitivity
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    d = dr.find_by_name("aspen 1")
    assert_equal "ASPEN 1", d.name
  end

  def test_returns_nil_if_cant_find_district_by_name
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    d = dr.find_by_name("lawls")
    assert d.nil?
  end

  def test_returns_an_array_of_all_districts_matching_a_fragment
    dr = DistrictRepository.new
    dr.create_districts(["ACADEMY 20", "ADAMS-ARAPAHOE 28J"])
    d = dr.find_all_matching("AD")
    assert_equal 2, d.count
    assert_equal "ACADEMY 20", d.first.name
    assert_equal "ADAMS-ARAPAHOE 28J", d.last.name
  end

  def test_returns_an_array_of_all_districts_matching_a_fragment_case_insensitive
    dr = DistrictRepository.new
    dr.create_districts(["ACADEMY 20", "ADAMS-ARAPAHOE 28J"])
    d = dr.find_all_matching("ad")
    assert_equal 2, d.count
    assert_equal "ACADEMY 20", d.first.name
    assert_equal "ADAMS-ARAPAHOE 28J", d.last.name
  end

  def test_returns_an_empty_array_if_fragment_doesnt_match_a_district
    dr = DistrictRepository.new
    dr.create_districts(["ACADEMY 20", "ADAMS-ARAPAHOE 28J"])
    d = dr.find_all_matching("X")
    assert_equal 0, d.count
    assert_equal [], d
  end

  def test_creates_a_relationship_between_district_and_enrollment
    dr = DistrictRepository.new
    dr.load_data(enrollment_file)
    district = dr.find_by_name("COLORADO")
    assert_equal "COLORADO", district.enrollment.name
  end

  def test_creates_a_relationship_between_statewide_and_enrollment
    dr = DistrictRepository.new
    dr.load_data(enrollment_statewide_files)

    district = dr.find_by_name("COLORADO")
    assert_equal "COLORADO", district.statewide_test.name
  end

  def test_creates_a_relationship_between_all_three_relationships
    dr = DistrictRepository.new
    dr.load_data(load_all_files)
    district = dr.find_by_name("COLORADO")
    assert_equal "COLORADO", district.economic_profile.name
  end
end
