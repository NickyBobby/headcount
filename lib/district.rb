class District
  attr_accessor :enrollment
  attr_reader :name

  def initialize(data)
    @name = data.fetch(:name).upcase
    @enrollment = nil
  end
end
