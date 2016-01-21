require "test_helper"
require "statewide_test_repository"

class StatewideTestRepositoryTest < Minitest::Test

  def test_starts_off_with_empty_statewide_tests
    str = StatewideTestRepository.new
    assert_equal [], str.statewide_tests
  end

  def test_can_load_data
    str = StatewideTestRepository.new
    str.load_data({
      statewide_testing: {
        third_grade: "./test/sample_third_grade.csv"
      }
    })
    statewide_test = str.statewide_test_exists("Colorado")

    assert_equal "COLORADO", statewide_test.name
  end

  def test_can_parse_a_CSV_file
    str = StatewideTestRepository.new
    data = { :statewide_testing => {
    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    }}
    csv_instance = str.parse_file(data)

    assert_instance_of CSV, csv_instance[:third_grade]
  end

  

end

class StatewideTestRepositoryIntegrationTest < Minitest::Test

  def test_can_load_data_into_enrollment_repository
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
      }
    })

    assert_instance_of StatewideTest, str.statewide_tests[0]
  end

  def test_can_extract_info_and_create_statewide_test
    str = StatewideTestRepository.new
    contents = { third_grade: [
      {
        district:    "Colorado",
        subject:     :math,
        time_frame:  "2010",
        data_format: "percentage",
        data:        "0.706"
      }
    ]}
    str.extract_contents(contents)

    assert_equal ["COLORADO"], str.statewide_tests.map(&:name)
  end

  def test_can_find_statewide_test_by_name
    str = StatewideTestRepository.new
    str.create_statewide_test({2010=>0.706}, {:grade=>:third_grade, :district=>"Colorado", :year=>2010, :proficiency=>0.706, :subject=>:math})
    st = str.find_by_name("Colorado")

    assert_instance_of StatewideTest, st
    assert_equal "COLORADO", st.name
  end

  def test_can_find_by_name_with_case_insensitivity
    str = StatewideTestRepository.new
    str.create_statewide_test({2010=>0.706}, {:grade=>:third_grade, :district=>"Colorado", :year=>2010, :proficiency=>0.706, :subject=>:math})
    str.create_statewide_test({2009=>0.862}, {:grade=>:third_grade, :district=>"ACADEMY 20", :year=>2009, :proficiency=>0.862, :subject=>:reading})

    st1 = str.find_by_name("ColOradO")
    st2 = str.find_by_name("academy 20")

    assert_equal "COLORADO", st1.name
    assert_equal "ACADEMY 20", st2.name
  end

  def test_returns_nil_if_cant_find_statewide_test_by_name
    str = StatewideTestRepository.new
    str.create_statewide_test({2010=>0.706}, {:grade=>:third_grade, :district=>"Colorado", :year=>2010, :proficiency=>0.706, :subject=>:math})
    no = str.find_by_name("NOOOOO")

    assert_nil no
  end

  def test_whether_statewide_test_exists
    str = StatewideTestRepository.new
    str.create_statewide_test({2010=>0.706}, {:grade=>:third_grade, :district=>"Colorado", :year=>2010, :proficiency=>0.706, :subject=>:math})
    statewide_test = str.statewide_test_exists("Colorado")

    assert_equal "COLORADO", statewide_test.name
  end



end
