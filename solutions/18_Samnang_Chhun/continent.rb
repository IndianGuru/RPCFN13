class Continent
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def ==(continent)
    @name == continent.name
  end
end
