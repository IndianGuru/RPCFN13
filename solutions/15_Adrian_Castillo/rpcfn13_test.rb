require 'test/unit'
require_relative 'programming_challenge'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @fd = FacebookData.new
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
    @order = [3, 1, 4, 2, 5, 0]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @fd.get_biggest_population[:population].to_i
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @fd.get_biggest_inflation.collect{|a, b| b}
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @fd.get_biggest_inflation.collect{|a, b| a.to_f}
  end

  def test_six_continents
    assert_equal@continents.sort, @fd.get_continents.keys.sort
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, @fd.get_continents[c].sort.join(', ')
    end
  end
end
