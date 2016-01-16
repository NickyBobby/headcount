require "pry"

class Enrollment
  attr_reader :name, :participation

  def initialize(data)
    @name = data[:name].upcase
    @participation = sanitize(data[:grade_participation])
  end

  def sanitize(participation)
    participation.each do |grade, participation_years|
      participation_years.each do |year, percent|
        participation[grade][year] = percent.to_f.round(3)
      end
    end
  end

  def kindergarten_participation_by_year
    participation[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    participation[:kindergarten][year]
  end

  def get_participation_average
    participation[:kindergarten].values
                                .inject(0, :+) / participation[:kindergarten].count
  end

  def get_graduation_average
    participation[:high_school_graduation].values
                                          .inject(0, :+) / participation[:high_school_graduation].count
  end

  def get_participation_average_by_year(enrollment)
    min, max = participation[:kindergarten].keys.minmax
    min.upto(max).each_with_object({}) do |year, avg|
      next unless participation[:kindergarten][year] && enrollment.participation[:kindergarten][year]
      average = participation[:kindergarten][year] / enrollment.participation[:kindergarten][year]
      avg[year] = average.round(3)
    end
  end

  def graduation_rate_by_year
    participation[:high_school_graduation]
  end

  def graduation_rate_in_year(year=nil)
    participation[:high_school_graduation][year]
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
