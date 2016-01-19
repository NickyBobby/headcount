require "test_helper"
require "economic_profile_repository"

class EconomicProfileRepositoryTest < Minitest::Test
  def test_can_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_data)
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", ep.name
  end

  def test_can_case_insensitively_find_economic_profile_by_name
    epr = EconomicProfileRepository.new
    epr.load_data(economic_profile_data)
    ep = epr.find_by_name("academy 20")
    assert_equal "ACADEMY 20", ep.name
  end
end
