require 'minitest/autorun'
require 'enrollment_repository'


class EnrollmentRepositoryTest < Minitest::Test

  def test_can_create_instances
    er = EnrollmentRepository.new

    assert_instance_of EnrollmentRepository, er
  end

  def test_can_parse_a_CSV_file
    er = EnrollmentRepository.new
    data = { enrollment: {
      kindergarten: "./test/sample_kindergarten.csv"
    }}
    csv_instance = er.parse_file(data)

    assert_instance_of CSV, csv_instance
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
    er.extract_info([
      {
        district:    "Colorado",
        time_frame:  "2010",
        data_format: "percentage",
        data:        "0.333"
      }
    ])

    assert_instance_of Enrollment, er.enrollments.first
    assert_equal "Colorado", er.enrollments.first.name
    assert_equal 1, er.enrollments.count
  end

  def test_can_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado",   { 2010 => 0.391 })
    e = er.find_by_name("Colorado")

    assert_instance_of Enrollment, e
    assert_equal "Colorado", e.name
  end

  def test_can_find_by_name_with_case_insensitivity
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado",   { 2010 => 0.391 })
    er.create_enrollment("ACADEMY 20", { 2010 => 0.391 })

    e = er.find_by_name("ColOradO")
    f = er.find_by_name("academy 20")

    assert_equal "Colorado", e.name
    assert_equal "ACADEMY 20", f.name
  end

  def test_returns_nil_if_cant_find_enrollment_by_name
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", { 2010 => 0.391 })
    no = er.find_by_name("NOOOOO")

    assert_nil no
  end

  def test_whether_enrollment_exists
    er = EnrollmentRepository.new
    er.create_enrollment("Colorado", { 2010 => 0.333 })
    enrollment = er.enrollment_exists("Colorado")

    assert_equal "Colorado", enrollment.name
  end

end
