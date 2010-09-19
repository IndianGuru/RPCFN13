$: << '.'
require 'cia_data'
describe 'Run tests against CIA data file from 1996' do
  before(:all) do
    @cia = CiaFile.new
  end

  it 'should return China as the largest country' do
    @cia.largest_country[:name].should eql('China')
  end

  it 'should return the countries with the 5 highest inflation rates' do
    inf = @cia.highest_inflation
    inf[0][:name].should eql('Yemen')
    inf[1][:name].should eql('Malawi')
    inf[2][:name].should eql('Azerbaijan')
    inf[3][:name].should eql('Turkey')
    inf[4][:name].should eql('Belarus')
  end

  it 'should return the alphabetized continents with alphabetized countries' do
    cc = @cia.continents_with_countries
    cc[0][:continent][:name].should eql('Africa')
    cc[1][:continent][:name].should eql('Asia')
    cc[2][:continent][:name].should eql('Australia/Oceania')
    cc[3][:continent][:name].should eql('Europe')
    cc[4][:continent][:name].should eql('North America')
    cc[5][:continent][:name].should eql('South America')

    describe 'it should test to see if countries are alphabetized' do
      it 'should begin with Algeria and end with Zimbabwe' do
        cc[0][:countries].first[:name].should eql('Algeria')
        cc[0][:countries].last[:name].should eql('Zimbabwe')
      end
      it 'should begin with Afghanistan and end with Yemen' do
        cc[1][:countries].first[:name].should eql('Afghanistan')
        cc[1][:countries].last[:name].should eql('Yemen')
      end
      it 'should begin with American Samoa and end with Western Samoa' do
        cc[2][:countries].first[:name].should eql('American Samoa')
        cc[2][:countries].last[:name].should eql('Western Samoa')
      end
      it 'should begin with Albania and end with United Kingdom' do
        cc[3][:countries].first[:name].should eql('Albania')
        cc[3][:countries].last[:name].should eql('United Kingdom')
      end
      it 'should begin with Anguilla and end with Virgin Islands' do
        cc[4][:countries].first[:name].should eql('Anguilla')
        cc[4][:countries].last[:name].should eql('Virgin Islands')
      end
      it 'should begin with Argentina and end with Venezuela' do
        cc[5][:countries].first[:name].should eql('Argentina')
        cc[5][:countries].last[:name].should eql('Venezuela')
      end
    end
  end
end
