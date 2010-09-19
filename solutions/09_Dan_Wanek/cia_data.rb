# I used Nokogiri for my XML parser because it was much faster processing the CIA file than REXML.
# The basis of my solution uses the Enumerable#sort_by method to display elements in the correct order.
require 'rubygems'
require 'nokogiri'

class CiaFile
  def initialize(file = '../cia-1996.xml')
    @doc = Nokogiri::XML(File.read(file))

    # Prefetch main elements
    @countries = @doc/'/cia/country'
    @continents = (@doc/'/cia/continent').sort_by {|c| c[:name]}
  end

  #  Question 1
  def largest_country
    @largest ||= @countries.sort_by {|country| country[:population].to_i}.last
  end

  #  Question 2
  def highest_inflation(return_count = 5)
    @countries.sort_by {|country| country[:inflation].to_i}.values_at(-return_count..-1)
  end

  # Question 3
  def continents_with_countries
    cdata = []
    @continents.each do |c|
      countries_by_name = (@doc/"//country[@continent='#{c[:name]}']").sort_by {|country| country[:name]}
      cdata << {:continent => c, :countries => countries_by_name}
    end
    cdata
  end
end
