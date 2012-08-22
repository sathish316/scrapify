## ScrApify

ScrApify is a library to build APIs by scraping static sites and use data as models or JSON APIs

### Installation

```
$ gem install scrapify
```

If you're using Bundler, add this to your Gemfile:

```
gem 'scrapify'
```

### Usage

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

Now you can use finder methods to extract data from a static site

```
> Pizza.all

> pizza = Pizza.find('mushroom')
> pizza.name
> pizza.image_url

> Pizza.first
> Pizza.last

> Pizza.count
```

### JSON API (Rack application example)

Scrapify comes with a Rack application called Jsonify which can expose scraped models as JSON.

Check out this [Rack application example](https://github.com/sathish316/jsonify_rack_example) for more details:

https://github.com/sathish316/jsonify_rack_example

In your Rack application map the routes you want to expose as JSON using Rack::Builder#map

```
  map '/pizzas' do
    run Jsonify.new('/pizzas', ::Pizza)
  end
```

This will respond to two urls index and show with JSON:

* /pizzas
* /pizzas/:id

Jsonify currently has a limitation where the URLs /pizzas.json and /pizzas/1.json cannot be matched by the same map entry in Rack routes

### JSON API (Rails example)

Scrapify comes with a Rack application called Jsonify which can be used in rails routes to expose scraped models as JSON.

Check out this [Rails example](https://github.com/sathish316/jsonify_rails_example) for more details:

https://github.com/sathish316/jsonify_rails_example

1 Add scrapify to Gemfile

```
gem 'scrapify'
```

2 Define model to scrap data in app/models

```
class Pizza
  include Scrapify::Base
end
```

3 Add index and show API to routes

```
  pizza_api = Jsonify.new('/pizzas', Pizza)
  get 'pizzas' => pizza_api
  get 'pizzas/:id' => pizza_api
```

Jsonify scraps url and exposes index and show urls as JSON APIs

## License

ScrApify is released under the MIT license:

http://www.opensource.org/licenses/MIT