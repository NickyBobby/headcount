require "district_repository"

class DistrictRepositoryTest < Minitest::Test
  def test_can_create_instances
    dr = DistrictRepository.new

    assert_instance_of DistrictRepository, dr
  end

  def test_can_create_districts
    dr = DistrictRepository.new
    dr.create_districts(["Chicago", "New Jersey"])

    assert_instance_of District, dr.districts.first
    assert_equal "CHICAGO", dr.districts.first.name
    assert_instance_of District, dr.districts.last
    assert_equal "NEW JERSEY", dr.districts.last.name
  end

  def test_can_parse_a_CSV_file
    dr = DistrictRepository.new
    options = { enrollment: {
      kindergarten: "./test/kindergartners_example.csv"
    }}
    csv_instance = dr.parse_file(options)

    assert_instance_of CSV, csv_instance
  end

  def test_can_get_location_column_from_CSV
    dr = DistrictRepository.new
    options = { enrollment: {
      kindergarten: "./test/kindergartners_example.csv"
    }}
    csv_contents = dr.parse_file(options)
    contents = dr.convert_csv_to_hashes(csv_contents)
    locations = dr.get_locations(contents)

    assert_instance_of Array, locations
    assert_equal "Colorado", locations.first
    assert_equal 30, locations.count
  end
end

class DistrictRepositoryIntegrationTest < Minitest::Test
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

  def test_returns_an_array_of_all_districts_matching_a_fragment_case_insensitive
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_all_matching("ad")

    assert_equal 4, d.count
    assert_equal 'COLORADO', d.first.name
    assert_equal 'ADAMS-ARAPAHOE 28J', d.last.name
  end

  def test_returns_an_empty_array_if_fragment_doesnt_match_a_district
    dr = DistrictRepository.new
    dr.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    d = dr.find_all_matching("X")

    assert_equal 0, d.count
    assert_equal [], d
  end
end
