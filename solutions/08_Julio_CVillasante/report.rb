require 'cia_world_factbook'

def print_report(cia)
  puts "CIA WORLD FACTBOOK 1996".center(80, '-')
  
  data = cia.country_with_most_people    
  puts wrap("The country with most people is #{data.first} and " + 
            "it's population is #{data.last}", 75, 2)
  
  data = cia.five_highest_inflation_rates
  puts wrap("The five highest inflation rates are:", 75, 2)
  data.each do |datum|
    puts wrap("#{datum.first} with an infletion of #{datum.last}", 75, 4)
  end
  
  data = cia.continents_list
  puts wrap("Continents and countries:", 75, 2)
  data.sort.each do |continent, countries|
    puts wrap("#{continent}:", 75, 4)
    puts wrap(countries.sort.join(", "), 75, 6)
  end
  
  puts "#{'-' * 80}"
end

def wrap(str, width=80, spaces=0)
  lines, line = [], ""
  
  str.split(/\s+/).each do |word|
    if line.size + word.size >= width
      lines << "#{' ' * spaces}#{line}"
      line = word
    elsif line.empty?
      line = word
    else
      line << ' ' << word
    end
  end
  lines << "#{' ' * spaces}#{line}" if line
  
  lines.join("\n")
end

print_report(CIAFacts.new)