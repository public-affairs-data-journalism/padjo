require 'mechanize'
require 'open-uri'
home_url = 'https://services.sccgov.org/facilityinspection/Home/Search'
results_url = "https://services.sccgov.org/facilityinspection/Home/ShowResults?pageno=1&countPerPage=100"
agent = Mechanize.new
agent.get home_url
# get those yummy cookies
agent.page.forms.count
agent.get results_url
table = agent.page.parser.css("table")[0]

results = table.css('tr')[1..-1].map do |row|
  cols = row.css('td')
  # example
  # "<tr>\r\n                            <td class=\"text-left\">\r\n                                <a href=\"/facilityinspection/Home/ShowDetail/PR0303370\" style=\"font-weight:bold\">SAFEWAY #700 BAKERY</a><br>\r\n                                <a href=\"http://maps.google.com/maps?daddr=2760%20%20HOMESTEAD%20RD&amp;lt;br/&amp;gt;SANTA%20CLARA,%20CA%2095051\" target=\"_blank\">2760  HOMESTEAD RD<br>SANTA CLARA, CA 95051</a>  <a href=\"http://maps.google.com/maps?daddr=2760%20%20HOMESTEAD%20RD&amp;lt;br/&amp;gt;SANTA%20CLARA,%20CA%2095051\" target=\"_blank\"><i class=\"fa fa-map-marker fa-lg\" style=\"color: #912D25; border-style: none none none none;\"></i></a>\r\n                            </td>\r\n                                <td class=\"bold-result text-info\">Not Available</td>\r\n                                <td class=\"bold-result text-info\">Not Available</td>\r\n\r\n                            <td class=\"text-left\">0.00 mi</td>\r\n                        </tr>"

end
