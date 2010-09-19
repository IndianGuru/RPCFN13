require 'nokogiri'

class FactBookParser
	def initialize(fact_book)
		@doc = Nokogiri::XML(File.new(fact_book, "r"))
		@countries = @doc.xpath("//country")
	end
	
	def highest_population
		population = @countries.xpath("//@population")
		population_max = population.max_by { |p| p.value.to_i }.value.to_i
		population_max_country = @doc.xpath("//country[@population=#{population_max}]").attribute("name").value
		[population_max_country, population_max]
	end
	
	def sort_by_inflation
		inflation = []
		@countries.each do |country|
			next if country.attribute("inflation").nil?
			inflation << [country.attribute("name").value, country.attribute("inflation").value.to_f]
		end
		inflation.sort! { |a, b| a.last <=> b.last }.reverse!
	end
	
	def highest_inflation(number)
		sort_by_inflation[0, number]
	end
	
	def continents
		@doc.xpath("//continent/@name").map { |c| c.value }.sort
	end
	
	def continents_with_countries
		cwc = {}
		continents.each do |continent|
			cwc[continent] = @doc.xpath("//country[@continent='#{continent}']").map { |country| country.attribute("name").value }.sort
		end
		cwc
	end	
end


=begin
require 'test/unit'

class FactBookParserTest < Test::Unit::TestCase
	def setup
		@fbp = FactBookParser.new("cia-1996.xml")
	end
	
	def test_highest_population
		assert_equal("China", @fbp.highest_population.first)
		assert_equal(1210004956, @fbp.highest_population.last)
	end
	
	def test_sort_by_inflation
		assert_equal([["Belarus",     244],
									["Turkey",      94],
									["Azerbaijan",  85]], 
									@fbp.sort_by_inflation[0..2])
		assert_equal([["Nauru",                      -3.6],
									["Saint Kitts and Nevis",      -0.9],
									["Oman",  										 -0.7]], 
									@fbp.sort_by_inflation.reverse[0..2])
	end
	
	def test_highest_inflation
		assert_equal([["Belarus",     244],
									["Turkey",      94],
									["Azerbaijan",  85],
									["Malawi",      83.3],
									["Yemen",       71.3]],  
									@fbp.highest_inflation(5))
	end
	
	def test_continents
		assert_equal(["Africa", "Asia", "Australia/Oceania", "Europe", "North America", "South America"], @fbp.continents)
	end
	
	def test_continents_and_countries
		cwc = @fbp.continents_with_countries
		assert_equal("Europe", cwc.keys[3])
		assert_equal("South America", cwc.keys[5])
		assert_equal(["Algeria", "Angola", "Bassas da India"], cwc["Africa"][0..2])
		assert_equal(["Cook Islands", "Coral Sea Islands", "Fiji"], cwc["Australia/Oceania"][3..5])
	end
end
=end
