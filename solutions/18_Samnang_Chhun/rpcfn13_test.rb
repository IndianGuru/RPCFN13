require 'test/unit'

%w{country continent economics_analyzer}.each do |f|
  require File.expand_path(File.join(File.dirname(__FILE__), f))
end

require_relative 'economics_analyzer'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @analyzer = EconomicsAnalyzer.new('../cia-1996.xml')
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
    @order = [3, 1, 4, 2, 5, 0]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @analyzer.get_the_highest_population_country.population
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @analyzer.get_the_top_five_highest_inflation_rates_countries.map(&:name)
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @analyzer.get_the_top_five_highest_inflation_rates_countries.map(&:inflation)
  end

  def test_six_continents
    assert_equal@continents, @analyzer.get_all_continents.map(&:name)
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    continents = @analyzer.get_all_continents.map(&:name)
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, @analyzer.get_all_countries_by_continent(continents[i]).map(&:name).join(', ')
    end
  end
end
