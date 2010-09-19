#!/usr/bin/env ruby

# added $ansx_x for unit test by ashbb

require 'rubygems'
require 'nokogiri'
class Integer
  def to_s_with_commas
    self.to_s.reverse.gsub(/\d{3}(?=\d)/,'\&,').reverse
  end
end

class CIA_DB
  attr_reader :continents,:countries
  def initialize(continents=nil,countries=nil)
    @continents=Continents.new(continents)
    @countries=Countries.new(countries)
  end

  class Node < Hash
    def datatype(key)
      :string
    end

    def initialize_attributes(node)
      node.attributes.each do |x,y|
        self[x]=case datatype(x)
        when :integer
          y.value.to_i
        when :float
          y.value.to_f
        else
          y.value
        end
      end
    end
  end

  class Continents < Hash
    def initialize(continents=nil)
      replace continents if continents
    end
  end

  class Continent < Node
    def initialize(node)
      initialize_attributes(node)
      self['countries']=Countries.new
    end
  end

  class Countries < Hash
    def self.country_attributes
      {:integer=>['population','total_area'],
       :float=>['inflation','population_growth',
       'infant_mortality','inflation','gdp_agri','gdp_ind', 'gdp_serv',
       'gdp_total'],
       :string=>['id','continent','name','datacode','indep_date',
       'government','capital']
      }
    end

    def self.numerics
      country_attributes[:integer]+country_attributes[:float]
    end

    def self.all_attributes
      numerics+country_attributes[:string]
    end

    def initialize(countries=nil)
      replace countries if countries
    end

    def numeric?(name)
      Countries.numerics.include?(name)
    end

    def collection(name)
      collect{ |x,y| [y['name'],y[name]||(numeric?(name) ? 0 : '')] }.sort_by{ |x| x[1] }
      #Note the || against the 2nd element, just in case the hash for this
      #element returns a nil force it to something that wont make the sort_by
      #barf.
    end

    def method_missing(methId)
      str=methId.id2name
      Countries.all_attributes.include?(str) ? collection(str) : super
    end

    def name
      collect{|x,y| y['name']}.sort
    end
  end

  class Country < Node
    def initialize(node)
      initialize_attributes(node)
    end

    def datatype(key)
      [:integer,:float,:string].each do |datatype|
        return datatype if Countries.country_attributes[datatype].include?(key)
      end
      :string
    end

    def <=> (other_country)
      self[name]<=>other_country[name]
    end
  end

  def self.load(fd)
    parse(Nokogiri::XML(fd.read))
  end

  def self.parse(doc)
    continents||={}
    countries||={}
    (doc/"continent").each do |x|
      new_continent=Continent.new(x)
      continents[new_continent['name']]=new_continent
    end
    (doc/"country").each do |x|
      new_country=Country.new(x)
      countries[new_country["id"]]=new_country
      continents[new_country["continent"]]['countries'][new_country["id"]]=new_country
    end
    new(continents,countries)
  end
end

#Tests and questions answered from here onwards.
#Note that most methods chained off the countries method return an array which contains a sorted
#(by method name ascending) list of arrays which further contain the country name and then the method
#requested values in their appropriate format (integer, float or string).
#The exception to this is the name method, which returns a sorted array of country names.

CIA_FILE='../cia-1996.xml'
cia=File.open(CIA_FILE) {|fd| CIA_DB::load(fd)}

puts("="*80)
puts("Q1. What is the population of the country with the most people?\nYes, we know it's China, but just how many people lived there in 1996?")

max_pop=cia.countries.population[-1]

puts("A. Highest population in 1996 was in %s of %s." % [max_pop[0],max_pop[1].to_s_with_commas])
$ans1 = max_pop[1]
puts("="*80)

puts("Q2. What are the five countries with the highest inflation rates, and what were those rates in 1996?")
puts("A. Five countries with the highest inflation rates")
puts("Country\t\tInflation Rate")

cia.countries.inflation[-5..-1].reverse.each {|x| puts("%-16s%3.1f" % x); $ans2_1 << x[0]; $ans2_2 << x[1]}

puts("="*80)

puts("Q3. What are the six continents in the file and which countries belong to which continent? Can you also produce them in alphabetical order?")

cia.continents.keys.sort.each do |continent_name|
  puts("Continent: #{continent_name}")
  $ans3_1 << continent_name
  $ans3_2[continent_name] = []
  cia.continents[continent_name]['countries'].name.each {|country_name| puts("\t#{country_name}"); $ans3_2[continent_name] << country_name }
end

puts("="*80)


puts("Now you're just showing off the method_missing DSL, aren't you?")
puts("A. Yes.")
puts("Five countries with the highest total area")
puts("Country\t\tTotal Area")

cia.countries.total_area[-5..-1].reverse.each {|x| puts("%-16s%08d" % x)}

puts("="*80)
puts("Five countries with the highest total gdp")
puts("Country\t\tTotal GDP")

cia.countries.gdp_total[-5..-1].reverse.each {|x| puts("%-16s%08.1f" % x)}

puts("="*80)
puts("Five countries with the highest agricultural gdp")
puts("Country\t\tTotal GDP")

cia.countries.gdp_agri[-5..-1].reverse.each {|x| puts("%-16s%3.1f" % x)}

puts("="*80)

cia.countries.capital.each {|x| puts("%-40s%-16s" % [x[1],x[0]])}
