module Sanitizer
  def self.sanitize(data)
    raise ArgumentError unless data.is_a? Hash
    data.each do |year, percent|
      data[year] = percent.to_f.round(3)
    end
  end
end
