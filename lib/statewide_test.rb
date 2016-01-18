

class StatewideTest
  attr_reader :name, :test_stats

  def initialize(data)
    @name = data[:name].upcase
    @test_stats = check_for_multiple_files(data)
  end

  def check_for_multiple_files(data)
    if data[:test_stats]
      sanitize_files(data[:test_stats])
    else
      sanitized_data = sanitize(data[:subject])
      { subject: sanitized_data }
    end
  end

  def sanitize(data)
    data.each do |year, percent|
      data[year] = percent.to_f.round(3)
    end
  end

  def sanitize_files(test_stats)
    test_stats.each do |subject, rate_by_year|
      rate_by_year.each do |year, percent|
        test_stats[subject][year] = percent #.to_f.round(3)
      end
    end
  end

end
