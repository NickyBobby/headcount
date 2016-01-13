require "pry"

class Enrollment
  attr_accessor :name, :participation

  def initialize(district_data)
    @name = district_data[:name]
    @participation = district_data[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    @participation
  end

  def kindergarten_participation_in_year(year)
    @participation[year]
  end

end

if __FILE__ == $0
e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
p e.kindergarten_participation_by_year
p e.kindergarten_participation_in_year(2010)
end
