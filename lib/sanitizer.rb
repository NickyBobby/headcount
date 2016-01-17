module Sanitizer
  def self.sanitize(data)
    data.each do |year, percent|
      data[year] = percent.to_f.round(3)
    end
  end
end
