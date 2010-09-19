require 'rexml/document'
require 'test/unit'

DESCENDING = -1

class Statistics
    def initialize(xml_file)
        @countries = Countries.new('../cia-1996.xml')
    end

    def most_populated 
        @countries.max_by(&:population)
    end

    def highest_5_inflation
        @countries.sort_by {|c| DESCENDING * c.inflation}.first(5)
    end

    def group_by_continent
        grouping = @countries.group_by(&:continent)
        sorted_grouping = {}
        grouping.keys.sort.each do |continent|
            sorted_grouping[continent] = grouping[continent].sort_by(&:name)
        end    
        return sorted_grouping
    end
end

class Countries
  include Enumerable

  def initialize(xml_file)
    doc = REXML::Document.new(File.new(xml_file))
    @countries = doc.elements.each('/cia/country') {|c| c}.map {|c| Country.new(c)}
  end

  def each
    @countries.each { |c| yield c }
  end
end

class Country
  ConversionMethod = Hash.new(:to_s).update(
  {
     :population => :to_i,
     :inflation  => :to_f,
  })

  def initialize(xml_element)
    @xml_element = xml_element
  end

  def method_missing(id, *args)
    attr = @xml_element.attributes[id.to_s]
    attr.send(self.class::ConversionMethod[id]) 
  end

  def to_s
    name
  end

end


=begin
class StatsTests < Test::Unit::TestCase

  def setup
     @stats = Statistics.new('../cia-1996.xml')
  end

  def test_most_populated
    most_populated = @stats.most_populated
    assert_equal('China', most_populated.name)
    assert_equal(1210004956, most_populated.population)
  end

  def test_inflation_list
    highest_5_inflation = @stats.highest_5_inflation
    assert_equal(5, highest_5_inflation.size)
    assert_equal('Belarus', highest_5_inflation[0].name)
    assert_equal(244, highest_5_inflation[0].inflation)
    assert_equal('Yemen', highest_5_inflation[4].name)
  end

  def test_continent_list
    continents = @stats.group_by_continent
    assert_equal(6, continents.size)
    assert_equal(%w{Africa Asia Australia/Oceania Europe North\ America South\ America}, continents.keys)
    assert_equal('Austria', continents['Europe'][2].name)
  end
end

# Display - BONUS :)

def display
  stats = Statistics.new('cia-1996.xml')

  most_populated = stats.most_populated
  highest_5_inflation = stats.highest_5_inflation
  continents = stats.group_by_continent

  def title(t)
    puts
    puts "=== #{t} ===" 
    puts
  end

  def subtitle(t)
    puts
    puts ' ' + t
    puts '-' * (t.size+1)
  end


  title("Highest population")
  puts "#{most_populated.name}: #{most_populated.population}"

  title("Highest 5 inflation")
  highest_5_inflation.each_with_index do |country, i| 
    longest_name = highest_5_inflation.max_by {|c| c.name.size}.name
    longest_inflation = highest_5_inflation.max_by {|c| c.inflation.to_s.size}.inflation
    cname = country.name.ljust(longest_name.size+1)
    infl = country.inflation.to_s.rjust(longest_inflation.to_s.size+1)
    puts "|#{i+1}. |#{cname}|#{infl}|"
  end

  title("All Continents")
  puts "Continents: " + continents.keys.join(', ')

  title("Countries by Continents")
  continents.keys.each do |continent|
    subtitle(continent)
    puts "\t" + continents[continent].join(", ") 
  end
end

#display

=end
