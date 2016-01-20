require "test_helper"
require "economic_profile_repository"

class EconomicProfileRepositoryTest < Minitest::Test
  def test_starts_off_with_empty_economic_profiles
    epr = EconomicProfileRepository.new
    assert_equal [], epr.economic_profiles
  end

  def test_can_load_in_data_and_create_economic_profile_objects
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_files)
    assert_instance_of EconomicProfile, epr.economic_profiles.first
  end

  def test_can_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_files)
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_can_case_insensitively_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_files)
    ep = epr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_returns_nil_if_cant_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_files)
    ep = epr.find_by_name("Zoolander")
    assert_nil ep
  end
end
