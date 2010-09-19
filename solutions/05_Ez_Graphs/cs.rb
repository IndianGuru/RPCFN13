# added $ansx_x for unit test by ashbb

require 'rubygems'
require 'hpricot'

doc= Hpricot(open('../cia-1996.xml'))

# What is the population of the country with the most people? 
r={}
(doc/"/cia/country").each{|n|r[n[:name]]=n[:population].to_i}
puts r.to_a.sort_by{|a,b|b}.reverse.first
$ans1 = r.to_a.sort_by{|a,b|b}.reverse.first[1]

# What are the five countries with the highest inflation rates, 
# and what were those rates in 1996?
r={}
(doc/"/cia/country").each{|n|r[n[:name]]=n[:inflation].to_f}
puts r.to_a.sort_by{|a,b|b}.reverse[0..4]
r.to_a.sort_by{|a,b|b}.reverse[0..4].each do |k, v|
  $ans2_1 << k
  $ans2_2 << v
end

# What are the six continents in the file and which 
# countries belong to which continent? 
# Can you also produce them in alphabetical order?
r=[]
(doc/"/cia/country").each{|n|r<<[n[:name],n[:continent]]; $ans3_1 << n[:continent]}
$ans3_1 = $ans3_1.uniq.sort
$ans3_1.each{|con| $ans3_2[con] = []}
r = r.sort_by{|a,b|b + a}
r.each{|e|puts "#{e[1]} #{e[0]}"; $ans3_2[e[1]] << e[0]}
