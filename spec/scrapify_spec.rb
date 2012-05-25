require 'spec_helper'
require 'test_models'

describe Scrapify do

  before do
    @pizza_url = "http://www.dominos.co.in/menuDetails_ajx.php?catgId=1"
    FakeWeb.register_uri :get, @pizza_url, :body => <<-HTML
      <ul class="menu_lft">
        <li><a>chicken supreme</a><input value="chicken.jpg"></li>
        <li><a>veg supreme</a><input value="veg.jpg"></li>
        <li><a>pepperoni</a><input value="pepperoni.jpg"></li>
      </ul>
    HTML
  end

  it "should return attribute names" do
    ::Pizza.attribute_names.should == [:name, :image_url]
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
end