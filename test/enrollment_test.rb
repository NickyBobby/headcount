require 'enrollment'

class EnrollmentTest < Minitest::Test

  def test_can_be_instantiated_on
    e = Enrollment.new(name: "Colorado")

    assert_instance_of Enrollment, e
  end

  def test_can_take_an_argument_with_a_name_in_it
    e = Enrollment.new(name: "Colorado")

    assert_equal "Colorado", e.name
  end

end
