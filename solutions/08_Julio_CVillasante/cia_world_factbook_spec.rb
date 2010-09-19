require 'cia_world_factbook'

describe "CIAFacts" do
  before do
    @cia = CIAFacts.new
  end
  
  it "should get country with most people" do
    actual = @cia.country_with_most_people
    actual.should == ['China', '1210004956']
  end
  
  it "should get five highest inflation rates" do
    actual = @cia.five_highest_inflation_rates
    actual.length.should == 5
    actual[0].should == ['Belarus', '244']
    actual[1].should == ['Turkey', '94']
    actual[2].should == ['Azerbaijan', '85']
    actual[3].should == ['Malawi', '83.3']
    actual[4].should == ['Yemen', '71.3']
  end
  
  it "should get continents and countries" do
    actual = @cia.continents_list
    actual.keys.length.should == 6
    actual.values.flatten.count.should == 260
    actual.keys.sort.should == ['Africa', 'Asia', 'Australia/Oceania', 'Europe', 'North America', 'South America']
    actual['Africa'][3].should == 'Benin'
    actual['Asia'][3].should == 'Azerbaijan'
    actual['Australia/Oceania'][5].should == 'Fiji'
    actual['Europe'][2].should == 'Austria'
  end
end