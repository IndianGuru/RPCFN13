require 'test/unit'
require_relative 'economics'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @world = World.current
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @world.most_populated_country.population
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @world.highest_inflation_countries(5).map(&:name)
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @world.highest_inflation_countries(5).map(&:inflation)
  end

  def test_six_continents
    assert_equal@continents, @world.continents.map(&:name)
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, @world.continents[i].countries.map(&:name).sort.join(', ')
    end
  end
end
