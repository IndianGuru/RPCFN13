require 'test/unit'
$ans2_1, $ans2_2, $ans3_1, $ans3_2 = [], [], [], {}
require_relative 'lukaszhanuszczak'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, $ans1.to_i
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], $ans2_1
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], $ans2_2
  end

  def test_six_continents
    assert_equal@continents.sort, $ans3_1
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, $ans3_2[c].join(', ')
    end
  end
end
