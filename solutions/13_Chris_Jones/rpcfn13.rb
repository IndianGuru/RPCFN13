class Factbook
  require "rexml/document"

  def initialize(book)
    file = File.new(book)
    doc = REXML::Document.new file
    @world = {}
    @continents = doc.root.elements.to_a("//continent").sort! { |a,b| a.attributes["name"] <=> b.attributes["name"] }
    @countries = doc.root.elements.to_a("//country")
  end

  def find_country_with_highest_population
    country_name, population = "", 0
    @countries.each do |country|
      if country.attributes["population"].to_i > population
        country_name, population = country.attributes["name"], country.attributes["population"].to_f  # replaced to_i to to_f for unit test by ashbb
      end
    end
    puts "1.  The country with the highest population (#{number_with_delimiter(population)} people) is #{country_name}."
    population  # added for unit test by ashbb
  end

  def find_top_5_countries_by_inflation_rate
    c, inf = [], []  # added for unit test by ashbb
    @countries.sort! { |a,b| b.attributes["inflation"].to_f <=> a.attributes["inflation"].to_f }
    puts "\n2.  Top 5 countries sorted by inflation rate:"
    @countries[0..4].each do |country|
      puts "    #{country.attributes["name"]} - #{country.attributes["inflation"]}%"
      c << country.attributes["name"]  # added for unit test by ashbb
      inf << country.attributes["inflation"].to_f  # added for unit test by ashbb
    end
    [c, inf]  # added for unit test by ashbb
  end

  def list_continents
    c = []  # added for unit test by ashbb
    puts "\n3a. #{@continents.count.to_s} continents found in factbook:"
    @continents.each { |continent| puts "    #{continent.attributes["name"]}"; c << continent.attributes["name"] }  # added for unit test by ashbb
    c  # added for unit test by ashbb
  end
  
  def list_countries_by_continent
    c = []  # added for unit test by ashbb
    order_countries
    puts "\n3b. #{@countries.count.to_s} countries found in factbook listed alphabetically by country:\n\n" 
    @world.each_pair { |continent, countries| c << very_pretty_print(continent,countries)}
    [@world, c]  # added for unit test by ashbb
  end

  private
  
  def number_with_delimiter(number, delimiter=",")
    number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
  end

  def order_countries
    @continents.each do |continent|      
      temp_continent = []
      @countries.each do |country|
        if country.attributes["continent"] == continent.attributes["name"] 
          temp_continent << country.attributes["name"] 
        end
      end          
      @world[continent.attributes["name"]] = temp_continent.sort! { |a,b| a <=> b }
    end
  end
  
  def very_pretty_print(continent, countries)
    print "#{continent.upcase}(#{countries.count.to_s}):"
    last_country = countries.pop
    countries.collect! { |c| " #{c}," }
    puts "#{countries.to_s} #{last_country}"
    last_country  # added for unit test by ashbb
  end
    
end

begin
factbook = Factbook.new("../cia-1996.xml")
factbook.find_country_with_highest_population
factbook.find_top_5_countries_by_inflation_rate
factbook.list_continents
factbook.list_countries_by_continent
end