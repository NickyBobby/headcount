require_relative "normalize"
require_relative "headcount_errors"

class StatewideTest
  attr_accessor :subjects
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    @subjects = Normalize.new.statewide_test_data(data[:subject])
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless [3, 8].include? grade
    grade = convert_to_grade_symbol[grade]
    min, max = subjects[grade][:math].keys.minmax
    build_subject_by_year(min, max, grade)
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownRaceError unless races.include? race
    min, max = subjects[:math][race].keys.minmax
    build_subject_by_year_and_race(min, max, race)
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless subject_list.include? subject
    yearly_proficency = proficient_by_grade(grade)
    raise UnknownDataError unless yearly_proficency[year]
    yearly_proficency[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless subject_list.include? subject
    yearly_proficency = proficient_by_race_or_ethnicity(race)
    raise UnknownDataError unless yearly_proficency[year]
    yearly_proficency[year][subject]
  end

  def year_over_year_growth(grade, subject, weighting = 0.33)
    grade = convert_to_grade_symbol[grade]
    years = subjects[grade][subject].keys.select do |year|
      subjects[grade][subject][year] > 0.0
    end.sort
    return 0.0 if years.count < 2
    ((subjects[grade][subject][years.last] - subjects[grade][subject][years.first]) /
    (years.last - years.first)) * weighting
  end

  def year_over_year_growth_all_subjects(data)
    if data[:weighting]
      growth = subject_list.inject(0) do |acc, subject|
        acc + year_over_year_growth(data[:grade], subject, data[:weighting][subject])
      end
      growth.round(3)
    else
      growth = subject_list.inject(0) do |acc, subject|
        acc + year_over_year_growth(data[:grade], subject)
      end
      growth.round(3)
    end
  end

  private

    def races
      [:asian, :black, :pacific_islander, :hispanic, :native_american,
       :two_or_more, :white]
    end

    def subject_list
      [:math, :reading, :writing]
    end

    def convert_to_grade_symbol
      { 3 => :third_grade, 8 => :eighth_grade }
    end

    def check_for_no_value(num)
      num == 0.0 ? "N/A" : num
    end

    def build_subject_by_year(min, max, grade)
      min.upto(max).each_with_object({}) do |year, obj|
        obj[year] = {
          math:    check_for_no_value(subjects[grade][:math][year]),
          reading: check_for_no_value(subjects[grade][:reading][year]),
          writing: check_for_no_value(subjects[grade][:writing][year])
        }
      end
    end

    def build_subject_by_year_and_race(min, max, race)
      min.upto(max).each_with_object({}) do |year, obj|
        obj[year] = {
          math:    check_for_no_value(subjects[:math][race][year]),
          reading: check_for_no_value(subjects[:reading][race][year]),
          writing: check_for_no_value(subjects[:writing][race][year])
        }
      end
    end
end
