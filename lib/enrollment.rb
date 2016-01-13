require "pry"

class Enrollment
  attr_accessor :name, :participation

  def initialize(district_data)
    @name = district_data[:name]#.upcase
    @participation = district_data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @participation
  end

  def kindergarten_participation_in_year(year)
    @particiation[year]
  end

end

if __FILE__ == $0
  e = Enrollment.new(name: "ACADEMY 20", kindergarten_participation: { 2010 => 0.3915, 2011 => 0.4})
end
