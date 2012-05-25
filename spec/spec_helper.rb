require 'rubygems'
require 'bundler/setup'
require 'rspec/mocks'
require 'fakeweb'

require 'scrapify'

RSpec.configure do |config|
  config.mock_with :mocha
end