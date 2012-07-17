class Book
  include Scrapify::Base
  html "http://www.books.com/pages/1"

  attribute :isbn, css: ".isbn"
  attribute :title, css: ".title"

  key :isbn

  next_page xpath: "//a[@class='next_page']/@href"
end
