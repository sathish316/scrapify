shared_examples_for "Scrapify" do |klass_or_object|
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
          <span class='references'><ol><li></li></ol></span
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
          <span class='references'><ol><li></li></ol></span
        </li>
        <li>
          <a>pepperoni</a><input value="pepperoni.jpg">
          <span class='price'>(3.45)</span>
          <span class='ingredients'></span>
          <span class='references'><ol><li></li></ol></span
        </li>
        <li>
          <a>chicken golden delight</a><input value="golden.jpg">
          <span class='price'>(4.56)</span>
          <span class='ingredients'/>
          <span class='references'>
            <ol>
              <li>
                <div href='chicken.html'>chicken</div>
                <div href='delight.html'>delight</div>
              </li>
            </ol>
          </span>
        </li>
      </ul>
    HTML
  end

  it "should return attribute names" do
    klass_or_object.attribute_names.should == [:name, :image_url, :price, :ingredients, :ingredient_urls]
  end

  describe "html" do
    it "should store url" do
      klass_or_object.url.should == @pizza_url
    end

    it "should parse html and fetch attributes using css" do
      klass_or_object.name_values.should == ['chicken supreme', 'veg supreme', 'pepperoni', 'chicken golden delight']
    end

    it "should parse html and fetch attributes using xpath" do
      klass_or_object.image_url_values.should == ['chicken.jpg', 'veg.jpg', 'pepperoni.jpg', 'golden.jpg']
    end

    it "should parse html and extract attributes using regex" do
      klass_or_object.price_values.should == ['1.23', '2.34', '3.45', '4.56']
    end

    it "should parse html and extract multiple attributes using regex" do
      klass_or_object.ingredients_values.should == [['corn','tomato'], ['mushroom','jalapeno'], [], []]
    end

    it 'should accept block to yield attribute values' do
      klass_or_object.ingredient_urls_values.should == [[], [], [], ['chicken.html', 'delight.html']]
    end

    it "should strip content" do
      klass_or_object.first.name.should == 'chicken supreme'
    end

    describe "cache headers" do
      it "should return the http headers" do
        klass_or_object.http_cache_header.should == {
           "cache-control" => "private, s-maxage=0, max-age=0, must-revalidate",
           "age"           => 51592,
        }
      end
    end
  end

  describe "find" do
    it "should find element by key" do
      pizza = klass_or_object.find('pepperoni')
      pizza.should_not be_nil
      pizza.name.should == 'pepperoni'
      pizza.image_url.should == 'pepperoni.jpg'
    end

    it "should be nil if element does not exist" do
      pizza = klass_or_object.find('mushroom')
      pizza.should be_nil
    end
  end

  describe "first" do
    it "should fetch first matching element" do
      first_pizza = klass_or_object.first
      first_pizza.name.should == 'chicken supreme'
      first_pizza.image_url.should == 'chicken.jpg'
    end
  end

  describe "last" do
    it "should fetch last matching element" do
      last_pizza = klass_or_object.last
      last_pizza.name.should == 'chicken golden delight'
      last_pizza.image_url.should == 'golden.jpg'
    end
  end

  describe "all" do
    it "should fetch all objects" do
      pizzas = klass_or_object.all
      pizzas.size.should == 4
      pizzas.map(&:name).should == ['chicken supreme', 'veg supreme', 'pepperoni', 'chicken golden delight']
      pizzas.map(&:image_url).should == ['chicken.jpg', 'veg.jpg', 'pepperoni.jpg', 'golden.jpg']
    end
  end

  describe "count" do
    it "should return number of matching elements" do
      klass_or_object.count.should == 4
    end
  end

  describe "attributes" do
    it "should return attributes hash" do
      first_pizza = klass_or_object.first
      first_pizza.attributes.should == {
        name: "chicken supreme",
        image_url: "chicken.jpg",
        price: '1.23',
        ingredients: ['corn', 'tomato'],
        ingredient_urls: []
      }
    end
  end

  describe "to_json" do
    it "should convert attributes to json" do
      first_pizza = klass_or_object.first
      first_pizza.to_json.should == {
        name: "chicken supreme",
        image_url: "chicken.jpg",
        price: '1.23',
        ingredients: ['corn', 'tomato'],
        ingredient_urls: []
      }.to_json
    end

    it "should convert array to json" do
      pizzas = klass_or_object.all
      pizzas.to_json.should == [
        {name: "chicken supreme", image_url: "chicken.jpg", price: '1.23', ingredients: ['corn', 'tomato'], :ingredient_urls => []},
        {name: "veg supreme", image_url: "veg.jpg", price: '2.34', ingredients: ['mushroom', 'jalapeno'], :ingredient_urls => []},
        {name: "pepperoni", image_url: "pepperoni.jpg", price: '3.45', ingredients: [], :ingredient_urls => []},
        {name: "chicken golden delight", image_url: "golden.jpg", price: '4.56', ingredients: [], :ingredient_urls => ['chicken.html', 'delight.html']},
      ].to_json
    end
  end
end
