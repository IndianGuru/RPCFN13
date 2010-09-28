require "rexml/document.rb"
include REXML
XMLFILE = "../cia-1996.xml"

class CIAFile1996
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # Parse xml file and create instance variable @world (REXML::Element), 
  # which we will use throughout our class methods.
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  def initialize
    xmlfile = File.new(XMLFILE)
    doc = Document.new xmlfile
    @world = doc.root
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # This method searches country with the highest population and returns
  # result in the form of an array with 2 objects (first object is String 
  # object representing name of the country, while second object is Integer
  # (actually Bignum...) object representing population number for that country).
  #
  # Example:
  #   max_population = ["China", 1210004956]
  #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  def highestPopulationCountry
    max_population = ["country name", 0]
    @world.elements.each { |country|
        if country.attributes["population"].to_i > max_population[1].to_i
          max_population[0] = country.attributes["name"]
          max_population[1] = country.attributes["population"].to_i
        end
    }
    return max_population
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # This method first creates Hash collection containing countries (keys) and 
  # their inflation rates (values). It then sorts Hash by element values, and 
  # then creates Array object with [country_name, inflation_value] element pairs.
  #
  # Example:
  #   a[0] = ["Belarus",244.0]
  #   a[1] = ["Turkey",94.0]
  #   ...
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  def topHighestInflationRates(nr)
    temp_arr = Hash.new
    @world.elements.each { |country|
      if country.attributes["inflation"]
        temp_arr[country.attributes["name"]] = country.attributes["inflation"].to_f
      end
    }
    temp_arr = temp_arr.sort{|a,b| b[1]<=>a[1]}
    a = Array.new
    counter = 0
    temp_arr.each { |country, value|
      (counter+=1)>=(nr+1) ? break : a.push([country, value])
    }
    return a
  end
  
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # This method creates Hash collection with key values representing continets
  # names. Values of Hash elements are arrays with String objects representing
  # country name. Arrays are sorted alphabetically.
  #
  # Example:
  #   a["Africa"] = ["Algeria", "Angola", "Bassas da India" ... etc]
  #   a["Europe"] = ["Albania", "Andorra", "Austria" ... etc]
  #   ...
  #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  def listCountriesByContinent
    a = Hash.new
    @world.elements.each{ |country|
      if country.attributes["continent"]
        if a[country.attributes["continent"]].class == Array
          a[country.attributes["continent"]].push(country.attributes["name"])
        else
          a[country.attributes["continent"]] = Array.new
          a[country.attributes["continent"]].push(country.attributes["name"])
        end
      end
    }
    a.each { |continent, countries|
      countries.sort!
    }
    return a
  end

end
