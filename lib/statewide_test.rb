require_relative "unknown_data_error"
require_relative "unknown_race_error"

class StatewideTest
  attr_accessor :subjects
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    @subjects = data[:subject]
  end

  def build_subject_by_year(min, max, grade)
    min.upto(max).each_with_object({}) do |year, obj|
      obj[year] = {
        math:    subjects[grade][:math][year],
        reading: subjects[grade][:reading][year],
        writing: subjects[grade][:writing][year]
      }
    end
  end

  def convert_to_grade_symbol
    { 3 => :third_grade, 8 => :eight_grade }
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless [3, 8].include? grade
    grade = convert_to_grade_symbol[grade]
    min, max = subjects[grade][:math].keys.minmax
    build_subject_by_year(min, max, grade)
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless races.include? race
    min, max = subjects[race][:math].keys.minmax
    build_subject_by_year(min, max, race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless subject_list.include? subject
    yearly_proficency = proficient_by_grade(grade)
    raise UnknownDataError unless yearly_proficency[year]
    yearly_proficency[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    yearly_proficency = proficient_by_race_or_ethnicity(race)
    yearly_proficency[year][subject]
  end

  private

    def races
      [:asian, :black, :pacific_islander, :hispanic, :native_american,
       :two_or_more, :white]
    end

    def subject_list
      [:math, :reading, :writing]
    end
end
