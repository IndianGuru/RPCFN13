# added $ansx-x for unit test by ashbb

require "rexml/document"
include REXML
file = File.new("../cia-1996.xml")
doc = REXML::Document.new file

# 1 
greatest_population_country = XPath.match(doc, "//country").sort{|a,b| b.attributes["population"].to_i <=> a.attributes["population"].to_i}.first

puts "Population of the country with the most people: #{$ans1 = greatest_population_country.attributes["population"]}. And the country is #{greatest_population_country.attributes["name"]}\n\n"

# 2
puts "Five countries with the highest inflation rates: \n"
XPath.match(doc, "//country").sort{|a,b| b.attributes["inflation"].to_i <=> a.attributes["inflation"].to_i}[0..4].each_with_index do |country, index|
  puts "#{index+1}. #{country.attributes["name"]} - #{country.attributes["inflation"]}\n"
  $ans2_1 << country.attributes["name"]
  $ans2_2 << country.attributes["inflation"].to_f
end

puts "\n"

# 3
puts "List of continents and countries belongs to them. Everything in alphabetical order:\n"
XPath.match(doc, "//continent").collect{|a| a.attributes["name"]}.sort{|a,b| a<=>b}.each do |continent_name|
  puts "#{continent_name}:"
  $ans3_1 << continent_name
  $ans3_2[continent_name] = []
  XPath.match(doc, "//country[@continent = '#{continent_name}']").sort{|a,b| a.attributes["name"] <=> b.attributes["name"]}.each do |country|
    puts country.attributes["name"]
    $ans3_2[continent_name] << country.attributes["name"]
  end
  puts "\n"
end
