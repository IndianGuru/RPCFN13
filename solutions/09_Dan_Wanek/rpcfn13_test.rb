require 'test/unit'
require_relative 'cia_data'

class EconomicsTest < Test::Unit::TestCase

  def setup
    @cia = CiaFile.new
    @data = IO.readlines('../answer3.txt')
    @continents = ["Europe", "Asia", "North America", "Australia/Oceania", "South America", "Africa"].sort
    @order = [3, 1, 4, 2, 5, 0]
  end
  
  def test_how_many_people_lived_China_in_1996
    assert_equal 1210004956, @cia.largest_country[:population].to_i
  end

  def test_five_countries_with_highest_inflation_and_rates
    assert_equal ["Belarus", "Turkey", "Azerbaijan", "Malawi", "Yemen"], @cia.highest_inflation.collect{|c| c[:name]}.reverse
  end

  def test_five_highest_inflation_rates
    assert_equal [244.0, 94.0, 85.0, 83.3, 71.3], @cia.highest_inflation.collect{|c| c[:inflation].to_f}.reverse
  end

  def test_six_continents
    assert_equal@continents, @cia.continents_with_countries.collect{|c| c[:continent][:name]}
  end

  def test_countries_belong_to_continents_in_alphabetical_order
    @continents.each_with_index do |c, i|
      assert_equal @data[i].chomp, @cia.continents_with_countries[@order[i]][:countries].collect{|c| c[:name]}.join(', ')
    end
  end
end
