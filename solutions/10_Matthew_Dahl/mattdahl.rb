# added $ansx_x for unit test by ashbb

# To run this script make sure it is in the same directory as cia-1966.xml (http://rubylearning.com/data/cia-1996.zip)
# and simply run the file via command line (ruby mattdahl.rb)
# Also note you need the hpricot gem so if you don't have it run (sudo gem install hpricot)

require 'rubygems'
gem 'hpricot'
require 'hpricot'

file = File.open('../cia-1996.xml', 'r')
doc = Hpricot(file)

continents = (doc/'continent')
countries = (doc/'country')

puts '1.'
country = countries.sort_by {|country| country.attributes['population'].to_i}.last
puts "\t#{country.attributes['name']} - #{country.attributes['population']}"
$ans1 = country.attributes['population']

puts '2.'
countries.sort_by {|country| country.attributes['inflation'].to_f}.reverse[0..4].each do |country|
  puts "\t#{country.attributes['name']} - #{country.attributes['inflation']}"
  $ans2_1 << country.attributes['name']
  $ans2_2 << country.attributes['inflation'].to_f
end

puts '3.'
countries.group_by {|country| country.attributes['continent']}.sort.each do |continent, countries|
  puts "\t#{continent}"
  $ans3_1 << continent
  $ans3_2[continent] = []
  countries.sort_by {|country| country.attributes['name']}.each do |country|
    puts "\t\t#{country.attributes['name']}"
    $ans3_2[continent] << country.attributes['name']
  end
end

file.close