require 'rubygems'
require 'spec'
%w{country continent economics_analyzer}.each do |f|
  require File.expand_path(File.join(File.dirname(__FILE__), f))
end

describe EconomicsAnalyzer do
  
  before do
    @analyzer = EconomicsAnalyzer.new("cia-1996.xml")  
  end
  
  it "should get the highest population country" do    
    expected_country = Country.new(:name => "China", :population => 1210004956)
    
    highest_population_country = @analyzer.get_the_highest_population_country

    highest_population_country.should == expected_country
  end
  
  it "should get the top 5 highest inflation rates countries" do
    expected_countries = [
                            Country.new(:name => 'Belarus', :inflation => 244.0),
                            Country.new(:name => 'Turkey', :inflation => 94.0),
                            Country.new(:name => 'Azerbaijan', :inflation => 85.0),
                            Country.new(:name => 'Malawi', :inflation => 83.299999999999997),
                            Country.new(:name => 'Yemen', :inflation => 71.299999999999997),
                         ]
                         
    top_five_countries = @analyzer.get_the_top_five_highest_inflation_rates_countries
    
    top_five_countries.each_with_index do |country, index|
      country.should == expected_countries[index]
    end
  end
  
  context "list continents" do
    
    it "should get all continents" do
      expected_number_of_continents = 6
      expected_the_first_continent = Continent.new("Europe")
      
      continents = @analyzer.get_all_continents
      
      continents.should have(expected_number_of_continents).continents
      continents.first.should == expected_the_first_continent
    end
    
    it "should get all countries in alphabetical order by each continent" do
      continents = ['Europe', 'Asia', 'North America', 
                    'Australia/Oceania', 'South America', 'Africa']
      expected_the_country_in_asia = Country.new(:name => "Cambodia")
      
      continents.each do |continent|
        sorted_countries = @analyzer.get_all_countries_by_continent(continent)
        sorted_countries.should have_at_least(1).country
      end
      
      countries_in_asia = @analyzer.get_all_countries_by_continent("Asia")
      
      countries_in_asia.should include(expected_the_country_in_asia)
    end
  end
end