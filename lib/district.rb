class District
  attr_accessor :enrollment, :statewide_test, :economic_profile
  attr_reader :name

  def initialize(data)
    @name             = data.fetch(:name).upcase
    @enrollment       = nil
    @statewide_test   = nil
    @economic_profile = nil
  end
end
