require "test_helper"
require "economic_profile_repository"

class EconomicProfileRepositoryTest < Minitest::Test
  def test_can_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_file)
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_can_case_insensitively_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_file)
    ep = epr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_can_detect_existing_economic_profile
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_file)
    ep = epr.economic_profile_exists("academy 20")
    assert_equal "ACADEMY 20", ep.name
  end
  
  def test_can_create_an_economic_profile
    epr = EconomicProfileRepository.new
    epr.create_economic_profile({:median_household_income=>{[2005, 2009]=>56222}, :name=>"Colorado"})
    ep = epr.economic_profile_exists("Colorado")

    assert_equal "COLORADO", ep.name
  end

end
