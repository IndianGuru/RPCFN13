require 'test/unit'
require_relative 'kallelindstrom'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @fbp = FactBookParser.new("../cia-1996.xml")
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
    @order = [3, 1, 4, 2, 5, 0]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @fbp.highest_population.last
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @fbp.sort_by_inflation[0..4].collect{|c| c[0]}
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @fbp.highest_inflation(5).collect{|c| c[1]}
  end

  def test_six_continents
    assert_equal@continents.sort, @fbp.continents
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      puts c
      assert_equal @data[i].chomp, @fbp.continents_with_countries[c].join(', ')
    end
  end
end
