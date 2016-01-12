require 'minitest/autorun'


class EnrollmentRepositoryTest < Minitest::Test

  def test_can_a_new_object_be_instatiated
    er = EnrollmentRepository.new

    assert_equal EnrollmentRepository, er.class
  end

  def test_can_I_load_data_into_enrollment_repository
    er = EnrollmentRepository.new

    
  end

end
