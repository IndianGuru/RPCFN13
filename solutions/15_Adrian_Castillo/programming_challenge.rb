require 'rexml/document'

class FacebookData
  def initialize
    file = File.new "../cia-1996.xml"
    doc = REXML::Document.new file

    @population = {}
    @inflation = [["",""]]
    @continents = {}

    doc.elements.each("*/continent") { |element| @continents.merge!({ element.attributes["name"] => [] }) }
    doc.elements.each("*/country") do |element|
      @population = { :name => element.attributes["name"], :population => element.attributes["population"]} if element.attributes["population"] && element.attributes["population"].to_i > @population[:population].to_i
      @inflation << [ element.attributes["inflation"], element.attributes["name"]] if element.attributes["inflation"] && element.attributes["inflation"].to_f > @inflation.last[1].to_f
      @continents[element.attributes["continent"]].push << element.attributes["name"]
    end
  end

  def get_biggest_population
    @population
  end

  def get_continents
    @continents
  end

  def get_continents_sorted
    @continents.sort
  end

  def get_biggest_inflation
    @inflation.sort{|x,y| y[0].to_f <=> x[0].to_f }[0..4]
  end
end

=begin
require 'rubygems'
gem 'test-unit', '>2.1'
require 'test/unit'

class MyTest < Test::Unit::TestCase

  DATA = FacebookData.new

  test "Testing Population" do
    assert_equal DATA.get_biggest_population[:name], 'China'
  end
 
  test "Testing inflation" do
    assert_equal DATA.get_biggest_inflation.length, 5
  end

  test "Testing continents " do
    continents = ['Africa', 'Asia', 'Australia/Oceania', 'Europe', 'North America', 'South America']
    assert_equal DATA.get_continents.length, 6
    continents.each{|continent| assert_equal DATA.get_continents.include?(continent), true, "Fail #{continent} continent #{DATA.get_continents}" }
  end
end
=end