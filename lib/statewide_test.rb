class StatewideTest
  attr_accessor :subjects
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    @subjects = data[:subject]
  end

  def proficient_by_grade(grade)
    result = {}
    if grade == 3
      subjects[:third_grade].each do |subject, year_rate|
        year_rate.each do |year, rate|
          if result[year].nil?
            result[year] = { subject => rate }
          else
            result[year].merge!({ subject => rate })
          end
        end
      end
    elsif grade == 8
      subjects[:eighth_grade].each do |subject, year_rate|
        year_rate.each do |year, rate|
          if result[year].nil?
            result[year] = { subject => rate }
          else
            result[year].merge!({ subject => rate })
          end
        end
      end
    end
    result
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    g = :third_grade if grade == 3
    g = :eighth_grade if grade == 8
    subjects[g][subject][year]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    subjects[race][subject][year]
  end
end
