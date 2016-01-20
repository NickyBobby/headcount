class Normalize
  def number(num)
    num.to_f.round(3)
  end

  def normalize_lunch(lunch_data)
    lunch_data.select do |data|
      data[:poverty_level] == "Eligible for Free or Reduced Lunch"
    end
  end

  def normalize_poverty(poverty_data)
    poverty_data.select do |data|
      data[:data_format] == "Percent"
    end
  end

  def normalize_economic_data_for_creation(profile, row)
    if profile == :median_household_income
      create_household_income_hash(profile, row)
    elsif profile == :free_or_reduced_price_lunch
      create_lunch_hash(profile, row)
    else
      create_economic_data_hash(profile, row)
    end
  end

  private

    def create_household_income_hash(profile, row)
      key = row[:time_frame].split("-").map(&:to_i)
      data = row[:data].to_i
      { profile => { key => data }, name: row[:district] }
    end

    def create_economic_data_hash(profile, row)
      key = row[:time_frame].to_i
      data = row[:data].to_f
      { profile => { key => data }, name: row[:district] }
    end

    def create_lunch_hash(profile, row)
      year = row[:time_frame].to_i
      if row[:data_format] == "Number"
        { profile => { year => { total: row[:data].to_i }}, name: row[:district] }
      elsif row[:data_format] == "Percent"
        { profile => { year => { percentage: row[:data].to_f }}, name: row[:district] }
      end
    end
end
