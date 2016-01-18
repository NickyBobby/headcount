require "test_helper"
require "district_repository"

class DistrictRepositoryTest < Minitest::Test
  def test_has_enrollment_repository_upon_creation
    dr = DistrictRepository.new

    assert_instance_of EnrollmentRepository, dr.er
  end
end

class DistrictRepositoryIntegrationTest < Minitest::Test
  def test_can_load_in_data_and_create_district_objects
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/sample_kindergarten.csv"
      }
    })

    assert_instance_of District, dr.districts[0]
  end

  def test_can_create_districts
    dr = DistrictRepository.new
    dr.create_districts(["Chicago", "New Jersey"])

    assert_equal ["CHICAGO", "NEW JERSEY"], dr.districts.map(&:name)
  end

  def test_can_find_district_by_name
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    d = dr.find_by_name("ASPEN 1")

    assert_instance_of District, d
    assert_equal "ASPEN 1", d.name
  end

  def test_can_find_district_by_name_with_case_insensitivity
    dr = DistrictRepository.new
    dr.create_districts(["ASPEN 1"])
    d = dr.find_by_name("aspen 1")

    assert_instance_of District, d
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
    dr.load_data({
      enrollment: {
        kindergarten: "./test/sample_kindergarten.csv"
      }
    })
    district = dr.find_by_name("COLORADO")
    assert_equal "COLORADO", district.enrollment.name
  end

  def test_creates_a_relationship_between_district_and_enrollment
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/sample_kindergarten.csv"
      },
      statewide_testing: {
        third_grade: "./test/sample_third_grade.csv"
      }
    })

    district = dr.find_by_name("COLORADO")
    assert_equal "COLORADO", district.statewide_test.name
  end
end
