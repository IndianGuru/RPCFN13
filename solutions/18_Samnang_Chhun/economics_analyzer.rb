require 'rexml/document'
require 'rexml/xpath'
include REXML

class EconomicsAnalyzer
  
  def initialize(file_name)
    File.open(file_name) do |file|
      @xml_document = Document.new(file)  
    end
  end
    
  def get_the_highest_population_country        
    find_the_highest_popultion_country(all_countries)
  end
  
  def get_the_top_five_highest_inflation_rates_countries
    find_the_top_five_highest_inflation_rates_counties(all_countries)
  end
  
  def get_all_continents    
    all_continents.collect { |continent| Continent.new(continent.attributes["name"]) }
  end
  
  def get_all_countries_by_continent(continent_name)
    sorted_countries = all_countries(continent_name).sort_by { |country| country.attributes["name"] }
    
    sorted_countries.collect { |country| Country.new(:name => country.attributes["name"]) }   
  end 
  
private
  def all_countries(continent_name = "")
    by_continent_name = "[@continent='#{continent_name}']" unless continent_name.empty?

    XPath.match(@xml_document, "/cia/country#{by_continent_name}")
  end
  
  def all_continents
    XPath.match(@xml_document, "/cia/continent")
  end
  
  def find_the_highest_popultion_country(countries)
    the_country = countries.max_by { |country| country.attributes["population"].to_i }
      
    Country.new(:name => the_country.attributes["name"], 
                :population => the_country.attributes["population"].to_i)
  end
  
  def find_the_top_five_highest_inflation_rates_counties(countries)
    countries = countries.sort_by { |country| country.attributes["inflation"].to_f }
    
    the_top_five_countries = countries.last(5).reverse
    the_top_five_countries.collect do |country|
      Country.new(:name => country.attributes["name"], 
                :inflation => country.attributes["inflation"].to_f)
    end
  end
end