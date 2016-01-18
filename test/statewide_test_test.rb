require "test_helper"
require "statewide_test"


class StatewideTestTest < Minitest::Test

  def test_can_create_an_instance_of
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
          third_grade: {
            math:    { 2008 => 0.857, 2009 => 0.824 },
            reading: { 2008 => 0.866, 2009 => 0.862 },
            writing: { 2008 => 0.671, 2009 => 0.706 }
          }
        })

    assert_instance_of StatewideTest, st
  end

  def test_can_get_proficiency_by_grade
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
          third_grade: {
            math:    { 2008 => 0.857, 2009 => 0.824 },
            reading: { 2008 => 0.866, 2009 => 0.862 },
            writing: { 2008 => 0.671, 2009 => 0.706 }
          }
        })

    expected = {
      2008 => {math: 0.857, reading: 0.866, writing: 0.671},
      2009 => {math: 0.824, reading: 0.862, writing: 0.706}
               }

    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_can_get_proficiency_by_different_grade
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
          eighth_grade: {
            math:    { 2008 => 0.64, 2009 => 0.656 },
            reading: { 2008 => 0.843, 2009 => 0.825 },
            writing: { 2008 => 0.734, 2009 => 0.701 }
          }
        })

    expected = {
      2008 => {math: 0.64, reading: 0.843, writing: 0.734},
      2009 => {math: 0.656, reading: 0.825, writing: 0.701}
               }

    assert_equal expected, st.proficient_by_grade(8)
  end

  def test_can_return_proficiency_for_subject_by_grade_in_year
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
          third_grade: {
            math:    { 2008 => 0.857, 2009 => 0.824 },
            reading: { 2008 => 0.866, 2009 => 0.862 },
            writing: { 2008 => 0.671, 2009 => 0.706 }
          }
        })

    assert_equal 0.857, st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end

  def test_can_return_proficiency_for_subject_by_different_grade_in_year
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
          eighth_grade: {
            math:    { 2008 => 0.64, 2009 => 0.656 },
            reading: { 2008 => 0.843, 2009 => 0.825 },
            writing: { 2008 => 0.734, 2009 => 0.701 }
          }
        })

    assert_equal 0.64, st.proficient_for_subject_by_grade_in_year(:math, 8, 2008)
  end
end
