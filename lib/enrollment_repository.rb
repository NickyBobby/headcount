require 'pry'
require 'csv'

class EnrollmentRepository

  def initialize
    @kindergarten = Hash.new

  end

  def load_data(enrollment_data)
    kindergarten_csv = enrollment_data[:enrollment][:kindergarten]
    contents = CSV.open kindergarten_csv, headers: true, header_converters: :symbols
    # parse_for_data(contents)
    contents.each do |row|
      binding.pry
    #   district = row[:location]
    #   year = row[:timeframe]
    #   participation = row[:data]
      # @kindergarten[:district] = Hash.new
    end

  end

  # def parse_for_data(contents)
  #   contents.each do |row|
  #     district = row[:location]
  #     year = row[:timeframe]
  #     participation = row[:data]
  #     @kindergarten[:district] = Hash.new
  #     binding.pry
  #   end
  # end

  def find_by_name

  end

end


er = EnrollmentRepository.new

er.load_data({
  :enrollment => {
    :kindergarten => "./data/Kindergartners in full-day program.csv"
  }
})
enrollment = er.find_by_name("ACADEMY 20")
# => <Enrollment>
