require "pry"

class Enrollment
  attr_reader :name, :participation

  def initialize(data)
    @name = data[:name].upcase
    @participation = sanitize(data[:kindergarten_participation])
  end

  def sanitize(participation)
    participation.each { |key, value| participation[key] = value.to_f.round(3) }
  end

  def kindergarten_participation_by_year
    participation
  end

  def kindergarten_participation_in_year(year)
    participation[year]
  end

  def get_participation_average
    participation.values.inject(0, :+) / participation.count
  end

  def get_participation_average_by_year(enrollment)
    min = participation.keys.min
    max = participation.keys.max
    min.upto(max).each_with_object({}) do |year, avg|
      next unless participation[year] && enrollment.participation[year]
      average = participation[year] / enrollment.participation[year]
      avg[year] = average.round(3)
    end
  end
end

# if __FILE__ == $0
#   e = Enrollment.new({:name => "ACADEMY 20",
#                       kindergarten_participation => {
#                         2010 => 0.3915,
#                         2011 => 0.35356,
#                         2012 => 0.2677 }})
#   p e.kindergarten_participation_by_year
#   p e.kindergarten_participation_in_year(2010)
# end
