class Pizza
  include Scrapify::Base
  html "http://www.dominos.co.in/menuDetails_ajx.php?catgId=1"

  attribute :name, css: ".menu_lft li a"
  attribute :image_url, xpath: "//li//input//@value"
  attribute :price, css: ".price", regex: /([\d\.]+)/
  attribute :ingredients, css: ".ingredients", regex: /contains (\w+)/, array: true
  attribute :ingredient_urls, css: '.references ol li' do |element|
    element.children.map do |child|
        child.attributes['href'].value if child.attributes['href']
    end.compact
  end

  key :name
end
