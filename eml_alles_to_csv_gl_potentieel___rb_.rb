require 'open-uri'
require 'csv'
require 'nokogiri' #html & XML parser

#dan het parsen
#stembureau = ReportingUnitVotes/ReportingUnitIdentifier

CSV.open("2014lokstemmen_perxml.csv", "w", {:col_sep => "\t"}) do |csv|
  csv << ["gemeente","stembureau","partij","stemmen"]
end


xmls = []
$aantal = Dir.glob("eml2014/*/*/Telling*.xml").size


Dir.glob("eml2014/*/*/Telling*.xml") do |doc|
  pad = File.absolute_path "#{doc}"
  xmls << pad
end

xmls.each_with_index do |dexml, indexer| #de xml == dexml
  CSV.open("2014lokstemmen_perxml.csv", "a", {:col_sep => "\t"}) do |csv|
  	#csv << ["gemeente","stembureau","partij","stemmen"]

      doc = Nokogiri::XML File.read(dexml) { |f| Nokogiri::XML(f) } #dit zou sneller moeten zijn
      gemeente = doc.css("AuthorityIdentifier").text #samesame
      doc.css('//ReportingUnitIdentifier').each_with_index do |char, index| #samesame
        puts ""
        puts ""
        puts "#{dexml}"
        puts "--------- #{indexer}/#{$aantal} ----------"
        puts "#{index}: #{char.text}"
        puts ""
        stembureau = char.text #stembureau

      ### ALTERNATIEF ###
      #doc.css('//ReportingUnitVotes').each_with_index do |char, index| #diff
      #  stembureau = doc.css('//ReportingUnitVotes')[index].children.css("ReportingUnitVotes")[0].text

        doc.css('//ReportingUnitVotes')[index].children.css("RegisteredName").each_with_index do |charr, indexx|
          partij = doc.css('//ReportingUnitVotes')[index].children.css("RegisteredName")[indexx].text
          stemmen = doc.css('//ReportingUnitVotes')[index].children.css("ValidVotes")[indexx].text
          puts "--------- #{indexer}/#{$aantal} ----------"
          puts "--#{partij}: #{stemmen}"
          csv << [gemeente,stembureau,partij,stemmen]
        end
      end
    end
  end



