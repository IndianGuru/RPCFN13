
require 'rubygems'
require 'nokogiri'

cia_xml = Nokogiri::XML(File.new('../cia-1996.xml'))

#a varaible for each data 
continents={}
avg_population =["",0]
avg_inflation = []

#loop troung all the xml nodes
cia_xml.root.xpath("country").each do |country|   
  #just a ordered hashmap for each country ;) 
  continents[country[:continent]]=[] if  continents[country[:continent]] == nil 
  continents[country[:continent]] << country[:name] 
  #convert to integer for finest comparation
  if (population = Integer(country[:population].to_i)) > avg_population[1]
      avg_population=country[:name],population
  end
  #not all the countries have a inflation value then just return  0 to the array
  avg_inflation << [country[:name],Float(country[:inflation] == nil ? 0 : country[:inflation])]
end

puts "The most populated country is #{avg_population[0]} with #{avg_population[1]} people"
$ans1 = avg_population[1]
$ans2, $ans3 = [], []

puts "The five countries with the most higth inflation are :"
#sort the array by the second value of the sub-array 
avg_inflation.sort!{|x,y| y[1] <=> x[1] }
#5 times buddy just 5 times
5.times do |i|
  puts " #{avg_inflation[i][0]} with #{avg_inflation[i][1]}"
  $ans2 << avg_inflation[i][0]
  $ans3 << avg_inflation[i][1]
end

puts "The Contients and his countries"


$ans4 = continents
$ans5 = {}
#sort the continents 
continents.to_a.sort!.each do |k,v|
  #just print the name of the contient
  puts k
  #sort by alpha magic ruby  and show it ! :D
  ($ans5[k] = v.sort!).each{|country| puts "\t #{country}" }
end
