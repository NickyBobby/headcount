require 'pry'
require 'csv'
require 'bigdecimal'

class EnrollmentRepository
  attr_reader :years, :kindergarten
  def initialize
    @kindergarten = Hash.new
    @years = Hash.new
  end

  def load_data(enrollment_data)
    kindergarten_csv = enrollment_data[:enrollment][:kindergarten]
    contents = CSV.open kindergarten_csv, headers: true, header_converters: :symbol
    parse_for_data(contents)
  end

  def parse_for_data(contents)
    contents.each do |row|
      district = row[:location]
      year = row[:timeframe]
      participation = row[:data][0..4].to_f
      # participation = BigDecimal.new(participation)
      years_hash(participation, year)
      # @years[year.to_sym] = participation
      @kindergarten[district.to_sym] = @years
    binding.pry
    end
  end

  def years_hash(participation, year)
    @years[year] = participation
  end

  def find_by_name(district)
    e = @kindergarten[district.to_sym]
    p e
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