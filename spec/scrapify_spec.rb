require 'spec_helper'
require 'test_models'

describe Scrapify do

  before do
    @pizza_url = "http://www.dominos.co.in/menuDetails_ajx.php?catgId=1"
    FakeWeb.register_uri :get, @pizza_url,
                         :cache_control => "private, s-maxage=0, max-age=0, must-revalidate",
                         :age           => 51592,
                         :length        => 12312,
                         :body          => <<-HTML
      <ul class="menu_lft">
        <li>
          <a>  chicken supreme  </a><input value="chicken.jpg">
          <span class='price'>(1.23)</span>
          <span class='ingredients'>
            <ol>
              <li>contains corn</li>
              <li>contains tomato</li>
            <ol>
          </span>
        </li>
        <li>
          <a>veg supreme</a><input value="veg.jpg">
          <span class='price'>(2.34)</span>
          <span class='ingredients'>
            <ol>
              <li>contains mushroom</li>
              <li>contains jalapeno</li>
            <ol>
          </span>
        </li>
        <li>
          <a>pepperoni</a><input value="pepperoni.jpg">
          <span class='price'>(3.45)</span>
          <span class='ingredients'></span>
        </li>
      </ul>
    HTML
  end

  it "should return attribute names" do
    ::Pizza.attribute_names.should == [:name, :image_url, :price, :ingredients]
  end

  describe "html" do
    it "should store url" do
      ::Pizza.url.should == @pizza_url
    end

    it "should parse html and fetch attributes using css" do
      ::Pizza.name_values.should == ['chicken supreme', 'veg supreme', 'pepperoni']
    end

    it "should parse html and fetch attributes using xpath" do
      ::Pizza.image_url_values.should == ['chicken.jpg', 'veg.jpg', 'pepperoni.jpg']
    end

    it "should parse html and extract attributes using regex" do
      ::Pizza.price_values.should == ['1.23', '2.34', '3.45']
    end

    it "should parse html and extract multiple attributes using regex" do
      ::Pizza.ingredients_values.should == [['corn','tomato'], ['mushroom','jalapeno'], []]
    end

    it "should strip content" do
      ::Pizza.first.name.should == 'chicken supreme'
    end

    describe "cache headers" do
      it "should return the http headers" do
        ::Pizza.http_cache_header.should == {
           "cache-control" => "private, s-maxage=0, max-age=0, must-revalidate",
           "age"           => 51592,
        }
      end
    end
  end

  describe "find" do
    it "should find element by key" do
      pizza = ::Pizza.find('pepperoni')
      pizza.should_not be_nil
      pizza.name.should == 'pepperoni'
      pizza.image_url.should == 'pepperoni.jpg'
    end

    it "should be nil if element does not exist" do
      pizza = ::Pizza.find('mushroom')
      pizza.should be_nil
    end
  end

  describe "first" do
    it "should fetch first matching element" do
      first_pizza = ::Pizza.first
      first_pizza.name.should == 'chicken supreme'
      first_pizza.image_url.should == 'chicken.jpg'
    end
  end

  describe "last" do
    it "should fetch last matching element" do
      last_pizza = ::Pizza.last
      last_pizza.name.should == 'pepperoni'
      last_pizza.image_url.should == 'pepperoni.jpg'
    end
  end

  describe "all" do
    it "should fetch all objects" do
      pizzas = ::Pizza.all
      pizzas.size.should == 3
      pizzas.map(&:name).should == ['chicken supreme', 'veg supreme', 'pepperoni']
      pizzas.map(&:image_url).should == ['chicken.jpg', 'veg.jpg', 'pepperoni.jpg']
    end
  end

  describe "count" do
    it "should return number of matching elements" do
      ::Pizza.count.should == 3
    end
  end

  describe "attributes" do
    it "should return attributes hash" do
      first_pizza = ::Pizza.first
      first_pizza.attributes.should == {
        name: "chicken supreme",
        image_url: "chicken.jpg",
        price: '1.23',
        ingredients: ['corn', 'tomato']
      }
    end
  end

  describe "to_json" do
    it "should convert attributes to json" do
      first_pizza = ::Pizza.first
      first_pizza.to_json.should == {
        name: "chicken supreme",
        image_url: "chicken.jpg",
        price: '1.23',
        ingredients: ['corn', 'tomato']
      }.to_json
    end

    it "should convert array to json" do
      pizzas = ::Pizza.all
      pizzas.to_json.should == [
        {name: "chicken supreme", image_url: "chicken.jpg", price: '1.23', ingredients: ['corn', 'tomato']},
        {name: "veg supreme", image_url: "veg.jpg", price: '2.34', ingredients: ['mushroom', 'jalapeno']},
        {name: "pepperoni", image_url: "pepperoni.jpg", price: '3.45', ingredients: []},
      ].to_json
    end
  end
end
