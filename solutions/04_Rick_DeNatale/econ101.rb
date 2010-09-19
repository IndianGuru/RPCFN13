# added $ansx_x for unit test by ashbb

require 'rubygems'
require 'nokogiri'

# Enumerable#max_by and Enumerable#group_by are implemented in Ruby 1.8.7 and Ruby 1.9. I want this to work in
# Ruby 1.8.6 also, just for the heck of it

unless Enumerable.instance_methods.include?(:max_by)
  module Enumerable
    def max_by(&block)
      map{|elem| [block[elem], elem]}.max.last
    end
    
    def group_by
      result = Hash.new {|hash,key| hash[key] = [] }
      each do |elem|
        result[yield elem] << elem
      end
      result
    end
  end
end

#File.open(ARGV[0]) do |f|
File.open('../cia-1996.xml') do |f|
  xml_doc = Nokogiri::XML::Document.parse(f)
  countries = xml_doc.css('country')
  most_populous = countries.max_by {|node| node['population'].to_i}
  puts "The most populous country in 1996 was #{most_populous['name']} with a population of #{$ans1 = most_populous['population']}"
  puts
  puts "The five countries with the highest inflation rate in 1996 were:"
  countries.sort_by {|country| -(country['inflation']  || 0).to_f} [0..4].each do |country|
    $ans2_1 << country['name']
    $ans2_2 << country['inflation'].to_f
    puts "  #{country['name']} - #{country['inflation']}%"
  end
  
  continent_info = countries.group_by {|country| country['continent']}
  puts
  puts "The continents and their countries in 1996 were:"
  continent_info.keys.sort.each do |continent|
    $ans3_1 << continent
    $ans3_2[continent] = []
    continent_info[continent].sort_by {|country|
      country['name']}.each do |country|
	$ans3_2[continent] << country['name']
        puts "  #{country['name']}"
      end
  end
end
