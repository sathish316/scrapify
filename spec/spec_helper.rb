require 'rubygems'
require 'bundler/setup'
require 'rspec/mocks'
require 'fakeweb'

require 'apify'

RSpec.configure do |config|
  config.mock_with :mocha
end