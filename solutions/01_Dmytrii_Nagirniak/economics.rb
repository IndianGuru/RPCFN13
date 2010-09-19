require 'rexml/document'

class Continent
  attr_reader :name, :countries

  def initialize(element)
    @name       = element.attributes['name']
    @countries  = []
  end
end


class Country
  attr_reader :name, :population, :inflation, :total_area
  attr_reader :continent

  def initialize(world, element)
    @name           = element.attributes['name']
    @population     = element.attributes['population'].to_i
    @inflation      = element.attributes['inflation'].to_f
    @total_area     = element.attributes['total_area'].to_f
    located_within  = element.attributes['continent']
    @continent  = world.continents.find {|c| c.name == located_within }
    @continent.countries.push self
  end
end

class World
  attr_reader :continents, :countries

  def self.current
    @world ||= World.new
  end

  def initialize(cia_file='../cia-1996.xml')
    # Yes, it will be slow, but it is done only once. So why sacrifice the Ruby-ish way!
    @continents, @countries = [], []
    doc = REXML::Document.new File.new cia_file
    doc.elements.each('cia/continent') { |e| @continents.push Continent.new(e) }
    doc.elements.each('cia/country') { |e| @countries.push Country.new(self, e) }
  end


  def most_populated_country
    countries.max { |a,b| a.population <=> b.population }
  end
  
  def highest_inflation_countries(top)
    countries.sort_by {|c| -c.inflation }.first top
  end
end