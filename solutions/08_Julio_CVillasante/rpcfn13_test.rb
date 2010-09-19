require 'test/unit'
require_relative 'cia_world_factbook'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @cia = CIAFacts.new
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @cia.country_with_most_people[1].to_i
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @cia.five_highest_inflation_rates.collect{|a, b| a}
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @cia.five_highest_inflation_rates.collect{|a, b| b.to_f}
  end

  def test_six_continents
    assert_equal@continents, @cia.continents_list.keys
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, @cia.continents_list[c].sort.join(', ')
    end
  end
end
