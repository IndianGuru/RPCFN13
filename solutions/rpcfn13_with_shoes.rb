require 'hpricot'

Shoes.app width: 1300, height: 800, title: 'RPCFN13: Economics 101 in 1996' do
  doc = open("cia-1996.xml"){|f| Hpricot f}

  flow margin_right: gutter do
    doc.search("//country[@name='China']").each do |e|
      e.to_html.sub(/population=\"(.*?)\"/){para "Chinese population:", stroke: green; para "#{$1}\n\n"}
    end
	  
    countries = []
    doc.search("//country").each do |e|
      e.to_html.sub(/continent=\"(.*?)\".*name=\"(.*?)\".*inflation=\"(.*?)\"/){countries << [$1, $2, $3.to_f]}
    end
    para "The five countries with the highest inflation rates: ", stroke: green
    para countries.sort_by{|e| e[2]}.reverse[0..4].collect{|c, n, i|"#{n} #{i}"}.join(', ') + "\n"
	  
    continents = []
    doc.search("//continent").each do |e|
      e.to_html.sub(/name=\"(.*?)\"/){continents << $1}
    end
    
    all_countries = []
    doc.search("//country").each do |e|
      e.to_html.sub(/continent=\"(.*?)\".*name=\"(.*?)\"/){all_countries << [$1, $2]}
    end
    
    h = {}
    continents.each do |continent|
      h[continent] = all_countries.collect{|c, n| n if c == continent}.-([nil]).sort
    end

    para "\nAll countries:\n", stroke: green
    continents.collect{|c| para "#{c}\n", stroke: blue; para "#{h[c].join ', '}\n\n"}
  end
end
