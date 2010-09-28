class Country
  attr_reader :name, :population, :inflation
  
  def initialize(options={})    
    options.each { |attr, value| instance_variable_set("@#{attr}", value) }
  end
  
  def ==(country)
    @name == country.name && 
    @population == country.population && 
    @inflation == country.inflation
  end
end
