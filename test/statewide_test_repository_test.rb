require "test_helper"
require "statewide_test_repository"


class StatewideTestRepositoryTest < Minitest::Test

  def test_can_parse_a_CSV_file
    str = StatewideTestRepository.new
    data = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
                            }
           }
    csv_instance = str.parse_file(data)


    assert_instance_of CSV, csv_instance[:third_grade]
  end

  def test_can_load_data_into_statewide_test_repository
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
    })

    assert_instance_of StatewideTest, str.statewide_tests[0]
  end



end
