# added $ansx_x for unit test by ashbb

require "rexml/document"
include REXML

doc = Document.new(File.new "../cia-1996.xml")

# -------------------------- 1 --------------------------
#i didn't find something like "first_match('name', 'China')" in REXML docs so i had to use each
doc.root.each_element_with_attribute("name", "China") { |element| puts "#{element.attribute "name"} population in 1996 was #{$ans1 = element.attribute("population").to_s}." }

# -------------------------- 2 --------------------------
inflation = []
doc.elements.each("cia/country") { |element| inflation << [element.attribute("inflation").to_s.to_f, element.attribute("name").to_s] }
puts "The highest inflation rates in 1996 were in:"
inflation.sort.reverse[0..4].each { |element| puts "#{element.last} (#{element.first})"; $ans2_1 << element.last; $ans2_2 << element.first}
# replaced reverse[1..5] to reverse[0..4] by ashbb

# -------------------------- 3 --------------------------
continents = {}
doc.elements.each("cia/continent") { |element| continents[element.attribute("name").to_s] = []}
doc.elements.each("cia/country") { |element| continents[element.attribute("continent").to_s] << element.attribute("name").to_s }

continents.sort.each { |countries|
  print "+ #{countries.first.upcase} (|"
  $ans3_1 << countries.first
  $ans3_2[countries.first] = []
  countries.last.sort.each { |name| print "#{name}|"; $ans3_2[countries.first] << name }
  print ")\n"
}

# -------------------------- Ruby 1.8.7 at Cygwin output --------------------------
=begin
China population in 1996 was 1210004956.
The highest inflation rates in 1996 were in:
Turkey (94.0)
Azerbaijan (85.0)
Malawi (83.3)
Yemen (71.3)
Ghana (69.0)
+ AFRICA (|Algeria|Angola|Bassas da India|Benin|Botswana|Bouvet Island|Burkina Faso|Burundi|Cameroon|Cape Verde|Central African Republic|Chad|Comoros|Congo|Cote dIvoire|Djibouti|Egypt|Equatorial Guinea|Eritrea|Ethiopia|Europa Island|French Southern and Antarctic Lands|Gabon|Gambia|Ghana|Glorioso Islands|Guinea|Guinea-Bissau|Heard Island and McDonald Islands|Juan de Nova Island|Kenya|Lesotho|Liberia|Libya|Madagascar|Malawi|Mali|Mauritania|Mauritius|Mayotte|Morocco|Mozambique|Namibia|Niger|Nigeria|Reunion|Rwanda|Saint Helena|Sao Tome and Principe|Senegal|Seychelles|Sierra Leone|Somalia|South Africa|Sudan|Swaziland|Tanzania|Togo|Tromelin Island|Tunisia|Uganda|Western Sahara|Zaire|Zambia|Zimbabwe|)
+ ASIA (|Afghanistan|Armenia|Ashmore and Cartier Islands|Azerbaijan|Bahrain|Bangladesh|Bhutan|British Indian Ocean Territory|Brunei|Burma|Cambodia|China|Christmas Island|Cocos Islands|Cyprus|Gaza Strip|Georgia|Hong Kong|India|Indonesia|Iran|Iraq|Israel|Japan|Jordan|Kazakstan|Kuwait|Kyrgyzstan|Laos|Lebanon|Macau|Malaysia|Maldives|Mongolia|Nepal|North Korea|Oman|Pakistan|Papua New Guinea|Paracel Islands|Philippines|Qatar|Russia|Saudi Arabia|Singapore|South Korea|Spratly Islands|Sri Lanka|Syria|Taiwan|Tajikistan|Thailand|Turkey|Turkmenistan|United Arab Emirates|Uzbekistan|Vietnam|West Bank|Yemen|)
+ AUSTRALIA/OCEANIA (|American Samoa|Australia|Baker Island|Cook Islands|Coral Sea Islands|Fiji|French Polynesia|Guam|Howland Island|Jarvis Island|Johnston Atoll|Kingman Reef|Kiribati|Marshall Islands|Micronesia|Midway Islands|Nauru|New Caledonia|New Zealand|Niue|Norfolk Island|Northern Mariana Islands|Palau|Palmyra Atoll|Pitcairn Islands|Solomon Islands|Tokelau|Tonga|Tuvalu|Vanuatu|Wake Island|Wallis and Futuna|Western Samoa|)
+ EUROPE (|Albania|Andorra|Austria|Belarus|Belgium|Bosnia and Herzegovina|Bulgaria|Croatia|Czech Republic|Denmark|Estonia|Faroe Islands|Finland|France|Germany|Gibraltar|Greece|Guernsey|Holy See|Hungary|Iceland|Ireland|Italy|Jan Mayen|Jersey|Latvia|Liechtenstein|Lithuania|Luxembourg|Macedonia|Malta|Man|Moldova|Monaco|Netherlands|Norway|Poland|Portugal|Romania|San Marino|Serbia and Montenegro|Slovakia|Slovenia|Spain|Svalbard|Sweden|Switzerland|Ukraine|United Kingdom|)
+ NORTH AMERICA (|Anguilla|Antigua and Barbuda|Aruba|Bahamas|Barbados|Belize|Bermuda|British Virgin Islands|Canada|Cayman Islands|Clipperton Island|Costa Rica|Cuba|Dominica|Dominican Republic|El Salvador|Greenland|Grenada|Guadeloupe|Guatemala|Haiti|Honduras|Jamaica|Martinique|Mexico|Montserrat|Navassa Island|Netherlands Antilles|Nicaragua|Panama|Puerto Rico|Saint Kitts and Nevis|Saint Lucia|Saint Pierre and Miquelon|Saint Vincent and the Grenadines|Trinidad and Tobago|Turks and Caicos Islands|United States|Virgin Islands|)
+ SOUTH AMERICA (|Argentina|Bolivia|Brazil|Chile|Colombia|Ecuador|Falkland Islands|French Guiana|Guyana|Paraguay|Peru|South Georgia and the South Sandwich Islands|Suriname|Uruguay|Venezuela|)
=end
