require './erm.rb'

=begin
 Pl. excuse the fact that the implementation in erm.rb is not especially lightweight 
 or targeted to just this particular assignment. It was an excuse to use many of the
 things newbies learn by following online tutorials on various topics and get some
 actual coding practice

 The attempt is to try and show, in a notional manner, how low level functionality
 (xml parsing in this case) can be packaged up in an Object Model with extra-simple
 API and re-used by multiple clients with similar needs.
 
 In this case the easy to use API consists of dynamically generated classes with 
 names that match the xml schema definition, with dynamically generated methods
 named the same as the attribute or relationship name and the values are automatically
 converted to the correct ruby type (String, FixNum, Float etc.)
=end

# Define the subset of the xml schema that we are interested in.
erm = define_erm_schema("cia") do
  entity 'continent', :id => :string, :name => :string
  entity 'country', :name => :string, :continent => :string, :population => :integer, :inflation => :float
  one_to_many_relationship 'countries_by_continent', 
              :source_class => 'continent', :target_class => 'country',
              :primary_key => 'name', :foreign_key => 'continent'

=begin
  PL. NOTE:  The implementation in erm.rb is not full featured. It only supports the
  few things neededed for this assignment.  For example, below is how a nested
  entity declaration might look like with a full implementation of ERM. Some child
  elements are fully contained (containment relationship) and others are with global
  elements (one to many or many to many relationships)
=end
#  entity 'country', :id => :string, :name => :string do
#    child 'borders'...
#    child 'coasts' ...
#  end
end

# Parse the xml file according to the defined schema subset
erm.parse "../cia-1996.xml"
by_population = erm.country.sort {|x,y| y.population <=> x.population }
populous = by_population.first
puts "\n#### 1. Most populous"
puts "#{populous.name} at: #{populous.population}\n"
$ans1 = populous.population

puts "\n#### 2. Most inflation"

$ans2 = by_inflation = erm.country.sort {|x,y| y.inflation <=> x.inflation }
(1 .. 5).each { |idx| puts "##{idx} #{by_inflation[idx-1].name} at: #{by_inflation[idx-1].inflation}"}

puts "\n#### 3. Continents with countries in alphabetical order"

$ans4, $ans5 = [], {}
erm.continent.each do |c|
  countries = c.get_targets('countries_by_continent')
  countries = c.countries_by_continent
  puts "   #{c.name} with #{countries.size} countries "
  $ans4 << c.name
  countries.sort! {|x, y| x.name <=> y.name}
  $ans5[c.name] = countries.map(&:name).join(', ')
  countries.each { |c| puts "        __ #{c.name}"}
end
