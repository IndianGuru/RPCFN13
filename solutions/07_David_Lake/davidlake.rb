# added $ansx_x for unit test by ashbb

# This version was developed on Ruby 1.9.2
gem 'activesupport', '<3.0.0' # Roxml doesn't like ActiveSupport 3...
require 'roxml' # I'm using version 3.1.5

# Pull helpers into a class that we can use to simplify the data
# declarations
class UberRoxml
  include ROXML

  def self.attribute_as(typ, *attr_names)
    attr_names.each do |attr_name|
      xml_accessor attr_name.to_sym, :from => :attr, :as => typ
    end
  end

  def self.string_attribute(*attr_names)
    attribute_as nil, *attr_names
  end
  
  def self.numeric_attribute(*attr_names)
    attribute_as Float, *attr_names
  end
  
  def self.integer_attribute(*attr_names)
    attribute_as Integer, *attr_names
  end
  
  def self.keyed_collection(node, key)
    xml_reader  node.to_sym, :as => {:key => "@#{key}", :value => :content }, :from => "#{node}s"
  end
  
  def self.unkeyed_collection(node)
    xml_reader  node.to_sym, :as => [], :from => "#{node}s"
  end
end

# Data declarations
class Continent < UberRoxml
  string_attribute :id, :name
end

class Country < UberRoxml
  string_attribute  :id, :name, :continent, :datacode, :indep_date, :government, :capital
  numeric_attribute :total_area, :population_growth, :infant_mortality, :inflation, :gdp_agr, :gdp_total
  integer_attribute :population
  
  keyed_collection :ethnicgroups, :name
  keyed_collection :religions, :name
  keyed_collection :languages, :name
  keyed_collection :borders, :country
  
  unkeyed_collection :coasts
  
  private
    def after_parse
      # Convert strings to floats where appropriate
      languages.each{|k,v| languages[k] = v.to_f}
      religions.each{|k,v| religions[k] = v.to_f}
    end
  
end

class CIAData  < UberRoxml
  xml_accessor :continents, :as => [Continent]
  xml_accessor :countries,  :as => [Country]
  
  private
    def after_parse
      # Make the references
      countries.each do |country|
        country.continent = continents.find {|continent| continent.name == country.continent}
        new_borders = {}
        country.borders.map do |bordering_country_name, value|
          bordering_country = countries.find {|test| test.id == bordering_country_name}
          new_borders[bordering_country] = value
        end
        country.borders.replace new_borders
      end
    end  
end

# Read the data
cia = CIAData.from_xml(File.read("../cia-1996.xml"))

# Take the challenge!
puts "Challenge 1. What is the population of the country with the most people?"
most_populous_country = cia.countries.max {|a,b| (a.population || 0) <=> (b.population || 0) }
puts "#{most_populous_country.name} has #{most_populous_country.population} people"
$ans1 = most_populous_country.population
puts

puts "Challenge 2. What are the five countries with the highest inflation rates, and what were those rates in 1996?"
countries_by_inflation_rate = cia.countries.sort {|a,b| (b.inflation || 0) <=> (a.inflation || 0) }
countries_by_inflation_rate[0..4].each_with_index do |country, index|   # replaced [0..5] to [0..4] by ashbb
  puts "#{1 + index}: #{country.name} #{country.inflation}%"
  $ans2_1 << country.name
  $ans2_2 << country.inflation
end
puts

puts "Challenge 3. What are the six continents in the file and which countries belong to which continent? Can you also produce them in alphabetical order?"
cia.continents.sort {|a,b| a.name <=> b.name }.each do |continent|
  puts continent.name + ':'
  $ans3_1 << continent.name
  $ans3_2[continent.name] = []
  members = cia.countries.find_all {|c| c.continent == continent}
  sorted_members = members.sort {|a,b| a.name <=> b.name }
  sorted_members.each do |country|
    puts " #{country.name}"
    $ans3_2[continent.name] << country.name
  end
end
