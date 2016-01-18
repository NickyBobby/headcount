require_relative "sanitizer"

class Enrollment
  attr_reader :name, :participation

  def initialize(data)
    @name = data[:name].upcase
    @participation = check_for_multiple_grades(data)
  end

  def kindergarten_participation_by_year
    participation[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    participation[:kindergarten][year]
  end

  def get_participation_average
    participation[:kindergarten].values.inject(0, :+) /
    participation[:kindergarten].count
  end

  def get_participation_average_by_year(enrollment)
    min, max = participation[:kindergarten].keys.minmax
    min.upto(max).each_with_object({}) do |year, avg|
      next unless participation[:kindergarten][year] &&
                  enrollment.participation[:kindergarten][year]
      avg[year] = (participation[:kindergarten][year] /
                   enrollment.participation[:kindergarten][year]).round(3)
    end
  end

  def graduation_rate_by_year
    participation[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    participation[:high_school_graduation][year]
  end

  def get_graduation_average
    (participation[:high_school_graduation].values
                                           .inject(0, :+) /
     participation[:high_school_graduation].count).round(3)
  end

  private

    def check_for_multiple_grades(data)
      if data[:grade_participation]
        Sanitizer.sanitize_grades(data[:grade_participation])
      else
        sanitized_data = Sanitizer.sanitize(data[:kindergarten_participation])
        { kindergarten: sanitized_data }
      end
    end
end
