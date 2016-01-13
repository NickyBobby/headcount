require 'minitest/autorun'
require 'enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test

  def test_can_a_new_object_be_instatiated
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end

  def test_can_load_data_into_enrollment_repository
    er = EnrollmentRepository.new
    er.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })

    assert_instance_of Enrollment, er.enrollments[0]
  end

  def test_can_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    e = er.find_by_name("Colorado")

    assert_instance_of Enrollment, e
    assert_equal "Colorado", e.name
  end

  def test_can_find_by_name_with_case_insensitivity
    er = EnrollmentRepository.new
    er.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    e = er.find_by_name("ColOradO")
    f = er.find_by_name("academy 20")

    assert_equal "Colorado", e.name
    assert_equal "ACADEMY 20", f.name
  end

  def test_returns_nil_if_cant_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.load_data({
      enrollment: {
        kindergarten: "./test/kindergartners_example.csv"
      }
    })
    no = er.find_by_name("NOOOOO")

    assert_nil no
  end

end
