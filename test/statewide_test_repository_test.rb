require "test_helper"
require "statewide_test_repository"

class StatewideTestRepositoryTest < Minitest::Test
  def test_starts_off_with_empty_statewide_tests
    str = StatewideTestRepository.new
    assert_equal [], str.statewide_tests
  end

  def test_can_load_data
  end
end
