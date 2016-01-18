class District
  attr_accessor :enrollment, :statewide_test
  attr_reader :name

  def initialize(data)
    @name = data.fetch(:name).upcase
    @enrollment     = nil
    @statewide_test = nil
  end
end
