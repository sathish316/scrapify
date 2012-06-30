shared_examples_for '#finder' do |klass_or_object, conditions|
  it 'should fetch objects based on conditions' do
    pizza = klass_or_object.where(conditions).first
    pizza.name.should == 'chicken golden delight'
    pizza.image_url.should == 'golden.jpg'
    pizza.price.should == '4.56'
    pizza.ingredients.should be_empty
    pizza.ingredient_urls.should == ['chicken.html', 'delight.html']
  end
end
