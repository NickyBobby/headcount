require "test_helper"


class StatewideTestRepositoryTest < Minitest::Test

  def test_can_parse_a_CSV_file
    str = StatewideTestRepository.new
    data = {
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
           }
    

    assert_instance_of CSV, csv_instance[:kindergarten]
  end




end
