require "test_helper"
require "enrollment_repository"

class EnrollmentRepositoryTest < Minitest::Test
  def test_starts_off_with_empty_enrollments
    er = EnrollmentRepository.new
    assert_equal [], er.enrollments
  end

  def test_can_load_in_data_and_create_enrollment_objects
    er = EnrollmentRepository.new
    data = { enrollment: {
      kindergarten: "./test/sample_kindergarten.csv"
    }}
    er.load_data(data)
    assert_instance_of Enrollment, er.enrollments.first
  end

  def test_can_connect_year_with_the_participation_rate
    er = EnrollmentRepository.new
    year_participation_hash = er.connect_year_by_participation(0.333, 2010)
    expected = { 2010 => 0.333 }

    assert_equal expected, year_participation_hash
  end
end

class EnrollmentRepositoryIntegrationTest < Minitest::Test

  def test_can_load_data_into_enrollment_repository
    er = EnrollmentRepository.new
    er.load_data({
      enrollment: {
        kindergarten: "./test/sample_kindergarten.csv"
      }
    })

    assert_instance_of Enrollment, er.enrollments[0]
  end

  def test_can_extract_info_and_create_enrollment
    er = EnrollmentRepository.new
    contents = { kindergarten: [
      {
        district:    "Colorado",
        time_frame:  "2010",
        data_format: "percentage",
        data:        "0.333"
      }
    ]}
    er.extract_info(contents)

    assert_equal ["COLORADO"], er.enrollments.map(&:name)
  end

  def test_can_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", :kindergarten, { 2010 => 0.391 })
    e = er.find_by_name("Colorado")

    assert_instance_of Enrollment, e
    assert_equal "COLORADO", e.name
  end

  def test_can_find_by_name_with_case_insensitivity
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", :kindergarten,   { 2010 => 0.391 })
    er.create_enrollment("ACADEMY 20", :kindergarten, { 2010 => 0.391 })

    e = er.find_by_name("ColOradO")
    f = er.find_by_name("academy 20")

    assert_equal "COLORADO", e.name
    assert_equal "ACADEMY 20", f.name
  end

  def test_returns_nil_if_cant_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", :kindergarten, { 2010 => 0.391 })
    no = er.find_by_name("NOOOOO")

    assert_nil no
  end

  def test_whether_enrollment_exists
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", :kindergarten, { 2010 => 0.333 })
    enrollment = er.enrollment_exists("Colorado")

    assert_equal "COLORADO", enrollment.name
  end
end
