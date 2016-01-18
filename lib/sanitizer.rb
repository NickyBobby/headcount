module Sanitizer
  def self.sanitize(data)
    raise ArgumentError unless data.is_a? Hash
    data.each do |year, percent|
      data[year] = percent.to_f.round(3)
    end
  end

  def self.sanitize_grades(grades)
    raise ArgumentError unless grades.is_a? Hash
    grades.each do |grade, participation_years|
      participation_years.each do |year, percent|
        grades[grade][year] = percent.to_f.round(3)
      end
    end
  end
end
