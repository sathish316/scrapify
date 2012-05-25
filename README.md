## ScrApify

ScrApify is a gem to easily scrap static html sites and make them look like REST APIs using an ActiveRecord-like querying interface

### Installation

```
$gem install scrapify
```

###

Usage example:

Define html url and declare attributes using xpath or css selectors.
Scrapify classes must have a key attribute defined.

```
class Pizza
  include Scrapify::Base
  html "http://www.dominos.co.in/menuDetails_ajx.php?catgId=1"

  attribute :name, css: ".menu_lft li a"
  attribute :image_url, xpath: "//li//input//@value"

  key :name
end
```