require "rexml/document"
file = File.new("../cia-1996.xml")
doc = REXML::Document.new file

# puts all of the xml information about the countries into an array of hashes
# This hash is used in all of the exercises
countries = []
doc.elements.each("cia/country") { |country| countries << country.attributes }


# sorts all the countries by population and lists the most populous country and its population
countries.sort_by! { |c| c["population"].to_i }
most_populous_country = countries[-1]
puts "The most populous country on the Earth is #{most_populous_country["name"]} with a population of #{$ans1 = most_populous_country["population"]} as of 1996."


# sorts all the countries by inflation rate and lists the five highest countries with their rates
# work on formatting for final output
inflation_array = countries.sort_by { |c| c["inflation"].to_f }.reverse
countries.sort_by! { |c| c["inflation"].to_f }
inflation_output = <<EOF
=============================================
Countries with Highest Inflation Rates (1996)
=============================================
EOF

$ans2, $ans3 = [], []
(1..5).each do |i|
  inflation_output << "#{i}. #{countries[-i]["name"]} #{'%.1f' % countries[-i]["inflation"]}\n"
  $ans2 << countries[-i]["name"]
  $ans3 << countries[-i]["inflation"]
end
puts inflation_output


# sorts all the countries by continent and then alphabetizes countries by continent
continents = []
doc.elements.each("cia/continent") { |continent| continents << continent.attributes }
continents.sort_by! { |continent| continent["name"] }

alpha_by_continent_output = ''
$ans4, $ans5 = [], {}
continents.each do |continent|
  $ans4 << continent["name"]
  $ans5[continent["name"]] = []
  alpha_by_continent_output << "\n" << continent["name"] << "\n=================\n"
  countries_in_continent = countries.find_all { |country| country["continent"] == continent["name"] }.sort_by { |country| country["name"] }
  countries_in_continent.each { |country| alpha_by_continent_output << country["name"] << "\n"; $ans5[continent["name"]].push country["name"]}
end
puts alpha_by_continent_output