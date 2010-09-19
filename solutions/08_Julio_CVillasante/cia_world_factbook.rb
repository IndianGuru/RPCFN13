require 'nokogiri'

class CIAFacts
  def initialize(xml_file = '../cia-1996.xml')
    @doc = Nokogiri::XML(File.open(xml_file))
  end
  
  def country_with_most_people
    node = @doc.xpath("//country/attribute::population").max_by { |x| x.text.to_i }
    [node.parent['name'], node.text]
  end
  
  def five_highest_inflation_rates
    nodes = @doc.xpath("//country/attribute::inflation").
      sort_by { |node| -node.text.to_f}.take(5)     # replaced to_i to to_f for unit test by ashbb
    
    nodes.inject([]) { |acc, node| acc << [node.parent['name'], node.text] }
  end
  
  def continents_list
    nodes = @doc.xpath("//country/attribute::continent")
    hash = Hash.new { |hash, key| hash[key] = [] }
    nodes.each { |node| hash[node.text] << node.parent['name'] }
    hash
  end
end