class Normalize
  def number(num)
    num.to_f.round(3)
  end

  def normalize_lunch(lunch_data)
    lunch_data.select do |data|
      data[:poverty_level] == "Eligible for Free or Reduced Lunch"
    end
  end
end
