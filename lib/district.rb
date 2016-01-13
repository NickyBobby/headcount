class District
  attr_reader :name

  def initialize(data)
    @name = data.fetch(:name).upcase
  end
end
