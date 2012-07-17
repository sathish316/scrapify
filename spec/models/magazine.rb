class Magazine
  include Scrapify::Base
  html ["http://www.magazines.com/pages/1", "http://www.magazines.com/pages/2", "http://www.magazines.com/pages/3"]

  attribute :issue, css: ".issue"
  attribute :title, css: ".title"

  key :issue
end