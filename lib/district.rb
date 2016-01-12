class District
  attr_reader :name

  def initialize(options)
    @name = options.fetch(:name).upcase
  end
end
