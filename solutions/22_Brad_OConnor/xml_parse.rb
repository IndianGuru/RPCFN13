require 'nokogiri'

f = File.open '../cia-1996.xml'
doc = Nokogiri::XML f
f.close

#Find population of the country with the most people

pop_nodes = doc.xpath "//@population"
pop_array = []
pop_nodes.each do |pop_node|
  pop_array << pop_node.value.to_i
end
puts "Population of the country with the most people is #{$ans1 = pop_array.max}\n\n"

#Find 5 countries with the highest inflation rates (and their inflation rates)

infl_nodes = doc.xpath "//@inflation"
infl_array = Array.new
infl_nodes.each do |infl_node|
  infl_array << {'inflation' => infl_node.value.to_f, 'country' => infl_node.parent.attributes['name'].to_s}
end

$ans2, $ans3 = [], []
infl_array = infl_array.sort_by {|a| a['inflation']}
puts "The 5 countries with the highest inflation rates are:"
(1..5).each do |num|
  puts "#{num}. #{infl_array[-num]['country']} (#{infl_array[-num]['inflation']})"
  $ans2 << infl_array[-num]['country']
  $ans3 << infl_array[-num]['inflation']
end
puts "\n"

#Find the 6 continents and list each country by continent in alphabetical order

continent_nodes = doc.xpath "//continent/@name"
continents = []
continent_nodes.each {|continent| continents << continent.to_s}
puts "The 6 continents in the file are:"
continents.each_with_index do |continent,index|
  puts "#{index+1}. #{continent}"
end
countries = Hash.new

$ans4 = continents
continents.each do |continent|
  countries[continent] = []
  country_list = doc.xpath "//country[@continent='#{continent}']/@name"
  country_list.each do |country|
    countries[continent] << country.to_s
  end
  countries[continent].sort!
end

$ans5 = countries
puts "\nThe following is a list of all countries in the files grouped by continent in alphabetical order"
continents.each do |continent|
  puts "#{continent}:"
  country_list = ""
  countries[continent].each do |country|
    country_list += country + ", "
  end
  puts country_list.chomp ", "
end
