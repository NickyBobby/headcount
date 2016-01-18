class StatewideTest
  attr_accessor :subjects
  attr_reader :name

  def initialize(data)
    @name = data[:name].upcase
    @subjects = data[:subject]
  end
end
