

class Enrollment(district_data)

  def initialize
    
    @name = district_data[:name]
    @participation = district_data[:]
  end

  def kindergarten_participation_by_year

  end

  def kindergarten_participation_in_year(year)

  end

end


e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677})
