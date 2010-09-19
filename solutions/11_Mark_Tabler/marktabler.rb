#RPCFN #13 challenge - Economics 101
#Written by Mark Tabler

require 'nokogiri'

class Country
  attr_accessor :name, :population, :inflation, :continent
  def initialize (name, continent, population = nil, inflation = nil)
    @name = name
    @continent = continent
    @population = population
    @inflation = inflation
  end
end

class Worldbook
  attr_accessor :countries, :xml_tree

  def initialize(doc_name)
    begin
      @countries = []
      @xml_tree = Nokogiri::XML(File.read(doc_name)).xpath("/cia/country")
      read_worldbook
    rescue IOError => e
      abort "Unable to read file #{doc_name}, aborting."
    end
  end

  def read_worldbook
    @xml_tree.each do |country|
      name = country.attributes['name'].value
      population = country.attributes['population'].value rescue nil
      inflation = country.attributes['inflation'].value rescue nil
      continent = country.attributes['continent'].value rescue nil
      add_country(name, continent, population, inflation)
    end
  end
  
  def add_country (name, continent, population, inflation)
    @countries << Country.new(name.to_s, continent.to_s, population.to_i, inflation.to_f)
  end
  
  def high_population
    @countries.sort_by!{ |country| country.population }.reverse!
    @countries.first
  end 

  def high_inflation
    @countries.sort_by!{ |country| country.inflation }.reverse!
    @countries.values_at(0..4)
  end
  
  def continent_list
    @countries.sort_by!{ |country| country.name }
    continent_list = {}
    @countries.each do |country|
      (continent_list[country.continent] ||= []) << country.name
    end
    continent_list
  end
end

def add_commas(n)
  n.to_s.reverse.scan(/\d{1,3}/).join(',').reverse
end


wb_1996 = Worldbook.new("../cia-1996.xml")

puts "\nHighest Population was held by #{wb_1996.high_population.name}"
puts "Its population was #{add_commas(wb_1996.high_population.population)}"

puts "\nThe five nations with the highest inflation index in 1996 were: "
wb_1996.high_inflation.each do |country|
  puts "#{country.name} with #{country.inflation} percent inflation"
end

puts "\nHere is a list of each continent in the 1996 World Factbook, \n"
puts "coupled with a list of each country on that continent.\n\n"
wb_1996.continent_list.each do |continent, countries|
  puts "#{continent}:"
  puts countries.join(", ")
end


__END__

