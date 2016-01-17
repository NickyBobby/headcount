

class StatewideTest
  attr_reader :name, :subject

  def initialize(data)
    @name = data[:name].upcase
    @subject = check_for_multiple_files(data)
  end

  def check_for_multiple_files(data)
    if data[:subject]
      sanitize_files(data[:subject])
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

  def sanitize_files(subject)
    subject.each do |subject, rate_by_year|
      rate_by_year.each do |year, percent|
        subject[subject][year] = percent.to_f.round(3)
      end
    end
  end

end
