=begin **************************************************************************
NAME:			Norman Eugene White
PROGRAM:		SeptContest.rb
CONTEST DETAILS:	http://rubylearning.com/blog/2010/08/31/rpcfn-economics-101-13/
TODAY'S DATE:	Sept. 16, 2010
DESCRIPTION:	I chose not to use any XML tool, but to do the parsing myself.
The parsing is a table-driven approach based on "The Parsing Table". This table
has the following fields:
The State (integer from 1 to 14) tells you what state you are in.
The Pattern that you are looking for in the text when in that state.
If you find the pattern, what state do you go to next.
If you do not find the pattern, what state do you go to next.
What action (if any) should you take when you hit this state (0=no action)
Collect means to start collecting characters until you hit the next pattern.

I have this program installed on both my home computer (C drive) and my work
computer (U drive), so the program prompts for this first.

It then prompts for the location of the XML input, and the text output.  I 
generally just hit return to take my default values.

You can generate an optional trace output, which just lists the data for each
country as it scans it.
=end ****************************************************************************

#******** What drive are you working with ***************************************
puts "What drive are you working with? ('U' or 'C')"
puts "Just enter the drive letter (i.e., 'C'"
myDrive=gets

#******** Get location of XML Input file and where to put Output files***********
puts "Please type in the location of the XML Input file"
puts 'Example: "C:\\Contest\\cia-1996\\cia-1996.xml"'
myInputFile=gets
if myInputFile.length < 3 then	#default value for Norm's use
	myInputFile= myDrive[0]+":\\Contest\\cia-1996\\cia-1996.xml"
end

#********************************************************************************
puts "Please type in the location of where you want the text output put"
puts 'Example: "C:\\Contest\\TextOutput.txt"'
myTextOutput=gets
if myTextOutput.length < 3	#default value for Norm's use
	myTextOutput= myDrive[0]+":\\Contest\\TextOutput.txt"
end

#*******************************************************************************
puts "Would you also like a Debugging Trace Output File? (Y or N)"
myResponse=gets
traceOn=0
if myResponse[0] == 'Y'
	puts "Please type in the location of where you want the trace file put"
	puts 'Example: "C:\\Contest\\MyTraceFile.txt"'
	myTraceFile=gets
	traceOn=1
	if myTraceFile.length < 3	#default value for Norm's use	
		myTraceFile= myDrive[0]+":\\Contest\\MyTraceFile.txt"	
	end
end
#*******************************************************************************


#********** Read in the XML Input File *****************************************
myFile = File.read(myInputFile)  
#*******************************************************************************

#********** Open the text output file ******************************************
outputFile = File::open(myTextOutput,'w')  
#*******************************************************************************

#********** Open the trace file if requested ***********************************
if traceOn == 1 
	tFile = File::open(myTraceFile,'w') 
end
#*******************************************************************************

#********** The Parsing Table **************************************************
#Row Pattern = [looking-for-this-pattern,true-exit,false-exit,action,collect]
row1=[1,'<continent',4,2,0,0]
row2=[2,'<country',7,3,0,0]
row3=[3,'</cia',0,0,1,0]

row4=[4,'name="',5,6,0,1]		#collecting name of continent
row5=[5,'"',1,6,3,0]			#action 3 save the name of the continent

row6=[6,' ',0,0,2,0]			#action 2 is an error

row7=[7,'continent="',8,6,0,1]	#collecting name of country's continent
row8=[8,'"',9,6,4,0]			#action 4 saves the name of the country's continent

row9=[9,'name="',10,6,0,1]		#collecting name of country
row10=[10,'"',11,6,5,0]			#action 5 saves the name of the country

row11=[11,'population="',12,6,0,1]	#collecting population of coujntry
row12=[12,'"',13,6,6,0]			#action 6 saves the population

row13=[13,'inflation="',14,6,0,1]	#collecting inflation rate of country
row14=[14,'"',2,6,7,0]			#action 7 saves the inflation rate

parsingTable=[row1,row2,row3,row4,row5,row6,row7,row8,row9,row10,row11,row12,row13,row14]
#*******************************************************************************


#**************** Loop Initialization ******************************************
state=1
prevState=0
x=0
i=0
continents=""
match=0
singleStep=0
collectSwitch=0
collectedWord=""
greatestPopulation=0
countryWithGreatestPopulation=""
highestInflationRate=Array.new
numberOfContinents=0
myContinents= ["","","","","",""]
continentCountries= ["","","","","",""]
#*******************************************************************************


#**************************** Main Loop ****************************************
while x==0 do
	#********** grab element from parsingTable for this state**********
	unless state==prevState then
		prevState=state	
		found=0
		for element in parsingTable
			if element[0] == state
				found=1
				pattern=element[1]
				trueState=element[2]
				falseState=element[3]
				action=element[4]
				collect=element[5]		
			end
		end 
		if found == 0 then
			x=1
			puts "Could not find parsingTable for state="+state.to_s
			exit
		end
	end

	#******************************************************************
	myChar=myFile[i]
	if collectSwitch == 1
		collectedWord<<myChar
	end
	myWord=myFile[i..i+pattern.length-1]	#next word from input
	if myWord[myWord.length-1] == "'"
		myWord=myWord[0,myWord.length-1]+'"'
	end

	#************ singleStep debugging tool **********************
	if singleStep == 1 then
		puts "myWord= "+myWord+"   pattern= "+pattern
		nothing=gets
		if nothing[0..3] == "quit" then
			singleStep=0
		end
	end
	#*************************************************************

	#******************** DOES THE INPUT MATCH THE PATTERN? *********
	if myWord == pattern then		
		state=trueState
		match=1
		i=i+pattern.length-1

		#******** See if we have any actions to do**************
		case
			when action==1	#We are finished, leave peacefully******************
				x=1

			when action==2	#Holy Moly, we have an unexpected error!************
				puts "We encountered a darn error"

			when action==3	#Process continent name******************************
				if collectedWord[collectedWord.length-1] == "'"
					collectedWord=collectedWord[0..collectedWord.length-2]
				end
				continents<<collectedWord+", "
				myContinents[numberOfContinents]=collectedWord
				numberOfContinents=numberOfContinents+1
				collectedWord=""
				collectSwitch=0
				if traceOn == 1	
					tFile<< "continents= " + continents + "\n"
				end

			when action==4	#Process the country's continent name****************
				if collectedWord[collectedWord.length-1] == "'"
					collectedWord=collectedWord[0..collectedWord.length-2]
				end
				countrysContinent=collectedWord
				collectedWord=""
				collectSwitch=0
				if traceOn == 1
					tFile<< "Found "+countrysContinent + " for some country\n"
				end

			when action==5	#Process the country's name*************************
				if collectedWord[collectedWord.length-1] == "'"
					collectedWord=collectedWord[0..collectedWord.length-2]
				end
				countryName=collectedWord
				collectedWord=""
				collectSwitch=0
				
				case
					when countrysContinent==myContinents[0]
						continentCountries[0]<<countryName+", "

					when countrysContinent==myContinents[1]
						continentCountries[1]<<countryName+", "

					when countrysContinent==myContinents[2]
						continentCountries[2]<<countryName+", "

					when countrysContinent==myContinents[3]
						continentCountries[3]<<countryName+", "

					when countrysContinent==myContinents[4]
						continentCountries[4]<<countryName+", "

					when countrysContinent==myContinents[5]
						continentCountries[5]<<countryName+", "
				end
				if traceOn == 1
					tFile<< "\nFound "+countryName + "\n"
				end

			when action==6	#Process the country's population******************
				if collectedWord[collectedWord.length-1] == "'"
					collectedWord=collectedWord[0..collectedWord.length-2]
				end
				population=collectedWord
				if population.to_i > greatestPopulation
					greatestPopulation=population.to_i
					countryWithGreatestPopulation=countryName
				end
				collectedWord=""
				collectSwitch=0
				if traceOn == 1
					tFile << "Found population of " + population + " for " + countryName + "\n"
				end

			when action==7	#Process the country's inflation rate************************************
				if collectedWord[collectedWord.length-1] == "'"
					collectedWord=collectedWord[0..collectedWord.length-2]
				end
				inflationRate=collectedWord
				highestInflationRate << [inflationRate.to_i,countryName]
				collectedWord=""
				collectSwitch=0
				if traceOn == 1
					tFile<< "Found inflation rate of " +inflationRate + "for " + countryName + "\n"
				end		
		end
		#*******************************************************

		#********* if 1 start collection characters*************
		if collect == 1 then
			collectSwitch=1
		end
		#*******************************************************
	end
	#*****************************************************************

	i=i+1			#advance pointer into myFile

	#************ could not find current patter, ran off end of file***
	if i >= myFile.length then	
		i=0				#reset to start at beginning of file
		state=falseState
	end
	#******************************************************************
end

outputFile << "This is Norm White's Text Output File\n"
outputFile<< Time.now
outputFile << "\n\n"

outputFile << "Country with greatest population in 1996 is "+countryWithGreatestPopulation+" with population of "+greatestPopulation.to_s
outputFile << "\n\n"

outputFile << "The five countries with the highest inflation rates are:\n"
aaa=highestInflationRate.sort
bbb=Array.new

bbb=aaa[-1]
aRate=bbb[0]
aCountry=bbb[1]
outputFile << aCountry + " has an inflation rate of " + aRate.to_s + "\n"

bbb=aaa[-2]
aRate=bbb[0]
aCountry=bbb[1]
outputFile << aCountry + " has an inflation rate of " + aRate.to_s + "\n"

bbb=aaa[-3]
aRate=bbb[0]
aCountry=bbb[1]
outputFile << aCountry + " has an inflation rate of " + aRate.to_s + "\n"

bbb=aaa[-4]
aRate=bbb[0]
aCountry=bbb[1]
outputFile << aCountry + " has an inflation rate of " + aRate.to_s + "\n"

bbb=aaa[-5]
aRate=bbb[0]
aCountry=bbb[1]
outputFile << aCountry + " has an inflation rate of " + aRate.to_s + "\n\n"

outputFile << "The six continents are: "+continents+"\n\n"

outputFile << "Countries in "+myContinents[0]+" are:\n"
outputFile << continentCountries[0]+"\n\n"

outputFile << "Countries in "+myContinents[1]+" are:\n"
outputFile << continentCountries[1]+"\n\n"

outputFile << "Countries in "+myContinents[2]+" are:\n"
outputFile << continentCountries[2]+"\n\n"

outputFile << "Countries in "+myContinents[3]+" are:\n"
outputFile << continentCountries[3]+"\n\n"

outputFile << "Countries in "+myContinents[4]+" are:\n"
outputFile << continentCountries[4]+"\n\n"

outputFile << "Countries in "+myContinents[5]+" are:\n"
outputFile << continentCountries[5]+"\n\n"
puts "Normal Program Completion"
=begin
This is Norm White's Text Output File
2010-09-17 10:27:11 -0400

Country with greatest population in 1996 is China with population of 1210004956

The five countries with the highest inflation rates are:
Belarus has an inflation rate of 244
Turkey has an inflation rate of 94
Ashmore and Cartier Islands has an inflation rate of 85
Malawi has an inflation rate of 83
Yemen has an inflation rate of 71

The six continents are: Europe, Asia, North America, Australia/Oceania, South America, Africa, 

Countries in Europe are:
Albania, Andorra, Belarus, Belgium, Bosnia and Herzegovina, Croatia, Czech Republic, Denmark, Estonia, Faroe Islands, Finland, France, Germany, Guernsey, Holy See, Iceland, Ireland, Italy, Jan Mayen, Liechtenstein, Lithuania, Luxembourg, Macedonia, Malta, Man, Moldova, Monaco, Norway, Poland, Portugal, Romania, San Marino, Serbia and Montenegro, Slovakia, Slovenia, Spain, Svalbard, Switzerland, Ukraine, United Kingdom, 

Countries in Asia are:
Afghanistan, Ashmore and Cartier Islands, Bahrain, Bangladesh, Bhutan, British Indian Ocean Territory, Burma, Cambodia, China, Christmas Island, Georgia, Hong Kong, India, Indonesia, Iran, Iraq, Japan, Jordan, Kazakstan, North Korea, Kuwait, Kyrgyzstan, Laos, Lebanon, Macau, Malaysia, Maldives, Mongolia, Nepal, Oman, Pakistan, Papua New Guinea, Paracel Islands, Qatar, Russia, Saudi Arabia, Singapore, Spratly Islands, Syria, Taiwan, Tajikistan, Thailand, Turkey, Turkmenistan, United Arab Emirates, Uzbekistan, Vietnam, West Bank, Yemen, 

Countries in North America are:
Anguilla, Antigua and Barbuda, Aruba, Bahamas, Barbados, Belize, Bermuda, British Virgin Islands, Canada, Cayman Islands, Clipperton Island, Cuba, Dominican Republic, El Salvador, Greenland, Grenada, Guadeloupe, Guatemala, Haiti, Honduras, Jamaica, Martinique, Mexico, Montserrat, Navassa Island, Nicaragua, Panama, Puerto Rico, Saint Kitts and Nevis, Saint Lucia, Saint Pierre and Miquelon, Trinidad and Tobago, Turks and Caicos Islands, Virgin Islands, 

Countries in Australia/Oceania are:
Baker Island, Coral Sea Islands, French Polynesia, Guam, Howland Island, Marshall Islands, Micronesia, Midway Islands, New Caledonia, New Zealand, Niue, Norfolk Island, Palau, Tokelau, Tuvalu, Vanuatu, Wake Island, 

Countries in South America are:
Argentina, Bolivia, Brazil, Chile, Colombia, Ecuador, Falkland Islands, Guyana, Paraguay, Peru, South Georgia and the South Sandwich Islands, Uruguay, Venezuela, 

Countries in Africa are:
Algeria, Angola, Bassas da India, Botswana, Bouvet Island, Burundi, Cameroon, Cape Verde, Central African Republic, Chad, Comoros, Congo, Cote dIvoire, Djibouti, Egypt, Equatorial Guinea, Eritrea, Ethiopia, Europa Island, Gambia, Ghana, Glorioso Islands, Guinea-Bissau, Heard Island and McDonald Islands, Lesotho, Liberia, Libya, Madagascar, Malawi, Mali, Mauritania, Mauritius, Mayotte, Mozambique, Namibia, Niger, Nigeria, Reunion, Saint Helena, Senegal, Seychelles, Sierra Leone, Somalia, Sudan, Swaziland, Tanzania, Togo, Tromelin Island, Uganda, Western Sahara, Zambia, Zimbabwe, 

=end