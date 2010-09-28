require "rpcfn13.rb"
require "test/unit.rb"

class REXMLParseTest < Test::Unit::TestCase
  
  @@xmlFile = CIAFile1996.new
  
  def test1
    puts "Testing highestPopulationCountry method..."
    a = @@xmlFile.highestPopulationCountry
    assert_equal "China", a[0]
    assert_equal 1210004956, a[1]
  end
  
  def test2
    puts "Testing topHighestInflationRates method..."
    a = @@xmlFile.topHighestInflationRates(5)
    assert_equal "Belarus", a[0][0]
    assert_equal 244.0, a[0][1]
    assert_equal "Turkey", a[1][0]
    assert_equal 94.0, a[1][1]
    assert_equal "Azerbaijan", a[2][0]
    assert_equal 85.0, a[2][1]
    assert_equal "Malawi", a[3][0]
    assert_equal 83.3, a[3][1]
    assert_equal "Yemen", a[4][0]
    assert_equal 71.3, a[4][1]
  end

  def test3
    puts "Testing listCountriesByContinent method..."
    a = @@xmlFile.listCountriesByContinent
    assert a["Africa"].include?("Morocco")
    assert a["Europe"].include?("Serbia and Montenegro")
    assert a["South America"].include?("Chile")
    assert a["Australia/Oceania"].include?("Niue")
    assert a["North America"].include?("Clipperton Island")
    assert a["Asia"].include?("Russia")
    assert_equal "Algeria", a["Africa"][0]
    assert_equal "Albania", a["Europe"][0]
    assert_equal "Argentina", a["South America"][0]
    assert_equal "American Samoa", a["Australia/Oceania"][0]
    assert_equal "Anguilla", a["North America"][0]
    assert_equal "Afghanistan", a["Asia"][0]
    assert_equal 260, a["Africa"].length + a["Europe"].length + a["South America"].length + a["Australia/Oceania"].length + a["North America"].length + a["Asia"].length
    assert_equal 6, a.keys.length
  end
end
