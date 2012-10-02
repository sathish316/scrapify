class HackerNews
  include Scrapify::Base
  html "http://news.ycombinator.com/news"

  attribute :rank, css: "tr:nth-child(3n+1) td.title:nth-child(1)"
  attribute :title, css: "tr:nth-child(3n+1) td.title:nth-child(3)"
  attribute :url, xpath: "//tr[position() mod 3 = 1]/td[@class='title'][position()=2]//@href"
  key :rank
end