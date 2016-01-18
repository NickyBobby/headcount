require "test_helper"
require "statewide_test"

class StatewideTestTest < Minitest::Test
  def test_returns_a_hash_for_third_grade_grouped_by_year_referencing_subject_proficiency
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           third_grade: {
             math:    { 2008 => 0.857, 2009 => 0.824 },
             reading: { 2008 => 0.866, 2009 => 0.862 },
             writing: { 2008 => 0.671, 2009 => 0.706 }
           }
         })
    expected = {
      2008 => { math: 0.857, reading: 0.866, writing: 0.671 },
      2009 => { math: 0.824, reading: 0.862, writing: 0.706 }
    }
    assert_equal expected, st.proficient_by_grade(3)
  end

  def test_returns_a_hash_for_eigth_grade_grouped_by_year_referencing_subject_proficiency
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           eight_grade: {
             math:    { 2008 => 0.872, 2009 => 0.854 },
             reading: { 2008 => 0.798, 2009 => 0.761 },
             writing: { 2008 => 0.921, 2009 => 0.901 }
           }
         })
    expected = {
      2008 => { math: 0.872, reading: 0.798, writing: 0.921 },
      2009 => { math: 0.854, reading: 0.761, writing: 0.901 }
    }
    assert_equal expected, st.proficient_by_grade(8)
  end

  def test_proficient_by_grade_throws_an_unknown_data_error_with_invalid_data
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           eight_grade: {
             math:    { 2008 => 0.872, 2009 => 0.854 },
             reading: { 2008 => 0.798, 2009 => 0.761 },
             writing: { 2008 => 0.921, 2009 => 0.901 }
           }
         })
    assert_raises UnknownDataError do
      st.proficient_by_grade(9)
    end
  end

  # write test for normalizing data
  # write test for UnknownDataError

  def test_returns_a_hash_for_race_grouped_by_year_referencing_subject_proficiency
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           asian: {
             math:    { 2011 => 0.816, 2012 => 0.818, 2013 => 0.805 },
             reading: { 2011 => 0.897, 2012 => 0.893, 2013 => 0.901 },
             writing: { 2011 => 0.826, 2012 => 0.808, 2013 => 0.810 }
           }
         })
    expected = {
      2011 => { math: 0.816, reading: 0.897, writing: 0.826 },
      2012 => { math: 0.818, reading: 0.893, writing: 0.808 },
      2013 => { math: 0.805, reading: 0.901, writing: 0.810 }
    }
    assert_equal expected, st.proficient_by_race_or_ethnicity(:asian)
  end

  def test_proficient_by_race_or_ethnicity_raises_an_unknown_race_error
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           asian: {
             math:    { 2011 => 0.816, 2012 => 0.818, 2013 => 0.805 },
             reading: { 2011 => 0.897, 2012 => 0.893, 2013 => 0.901 },
             writing: { 2011 => 0.826, 2012 => 0.808, 2013 => 0.810 }
           }
         })
    assert_raises UnknownRaceError do
      st.proficient_by_race_or_ethnicity(:english)
    end
  end

  # write test for UnknownDataError

  def test_returns_proficency_for_subject_by_grade_in_year
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           third_grade: {
             math:    { 2008 => 0.857, 2009 => 0.824 },
             reading: { 2008 => 0.866, 2009 => 0.862 },
             writing: { 2008 => 0.671, 2009 => 0.706 }
           }
         })
    proficency = st.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
    assert_equal 0.857, proficency
  end

  def test_proficency_for_subject_by_grade_in_year_throws_an_unknown_data_error
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           third_grade: {
             math:    { 2008 => 0.857, 2009 => 0.824 },
             reading: { 2008 => 0.866, 2009 => 0.862 },
             writing: { 2008 => 0.671, 2009 => 0.706 }
           }
         })
    assert_raises UnknownDataError do
      st.proficient_for_subject_by_grade_in_year(:science, 3, 2008)
    end
  end

  def test_proficency_for_subject_by_grade_in_year_throws_error_for_invalid_year
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           third_grade: {
             math:    { 2008 => 0.857, 2009 => 0.824 },
             reading: { 2008 => 0.866, 2009 => 0.862 },
             writing: { 2008 => 0.671, 2009 => 0.706 }
           }
         })
    assert_raises UnknownDataError do
      st.proficient_for_subject_by_grade_in_year(:math, 3, 2010)
    end
  end

  def test_returns_proficency_for_subject_by_race_in_year
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           asian: {
             math:    { 2011 => 0.816, 2012 => 0.818, 2013 => 0.805 },
             reading: { 2011 => 0.897, 2012 => 0.893, 2013 => 0.901 },
             writing: { 2011 => 0.826, 2012 => 0.808, 2013 => 0.810 }
           }
         })
    proficency = st.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
    assert_equal 0.818, proficency
  end

  def test_proficency_for_subject_by_race_in_year_throws_unknown_data_error
    st = StatewideTest.new(name: "ACADEMY 20", subject: {
           asian: {
             math:    { 2011 => 0.816, 2012 => 0.818, 2013 => 0.805 },
             reading: { 2011 => 0.897, 2012 => 0.893, 2013 => 0.901 },
             writing: { 2011 => 0.826, 2012 => 0.808, 2013 => 0.810 }
           }
         })
    assert_raises UnknownDataError do
      st.proficient_for_subject_by_race_in_year(:science, :asian, 2011)
    end
  end
end
