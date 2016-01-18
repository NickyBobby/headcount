class Normalize
  def number(num)
    num.to_f.round(3)
  end

  def normalize_lunch(lunch_data)
    lunch_data.each_with_index do |data, i|
      unless data[:poverty_level] == "Eligible for Free or Reduced Lunch"
        lunch_data.delete_at i
      end
    end
  end
end
