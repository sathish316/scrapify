require 'rubygems'
require 'bundler/setup'
require 'rspec/mocks'
require 'fakeweb'

require 'scrapify'
Dir["./spec/shared/*.rb"].each {|f| require File.expand_path(f)}

RSpec.configure do |config|
  config.mock_with :mocha
end
