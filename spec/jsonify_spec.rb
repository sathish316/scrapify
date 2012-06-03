require 'spec_helper'
require 'test_models'

describe Jsonify do
  before do
    ::Pizza.stubs(:http_cache_header).returns("cache-control" => "private")
    ::Pizza.stubs(:all).returns([])
  end

  it "should find all objects and convert to json for index url" do
    pizzas = [{name: 'cheese'}, {name: 'chicken'}]
    ::Pizza.expects(:all).returns(pizzas)

    jsonify = Jsonify.new('/pizzas', ::Pizza)
    status, header, response = jsonify.call('REQUEST_PATH' => '/pizzas')

    status.should == 200
    header['Content-Type'].should == 'application/json'
    response.first.should == pizzas.to_json
  end

  it "should find object by id and convert to json for show url" do
    pizza = {name: 'cheese'}
    ::Pizza.expects(:find).with('cheese').returns(pizza)

    jsonify = Jsonify.new('/pizzas', ::Pizza)
    status, header, response = jsonify.call('REQUEST_PATH' => '/pizzas/cheese')

    status.should == 200
    header['Content-Type'].should == 'application/json'
    response.first.should == pizza.to_json
  end

  it "should forward the http cache headers" do
    ::Pizza.expects(:http_cache_header).returns("cache-control"=>"private")

    jsonify = Jsonify.new('/pizzas', ::Pizza)
    status, header, response = jsonify.call('REQUEST_PATH' => '/pizzas')
    header['cache-control'].should == "private"
  end
end
