require 'spec_helper'
require 'test_models'
require 'active_support/core_ext/hash/keys'

describe Scrapify::Scraper do
  def self.attributes
    {:name => {:css => ".menu_lft li a"},
                :image_url => {:xpath => "//li//input//@value"},
                :price => {:css => ".price", :regex => /([\d\.]+)/},
                :ingredients => {:css => ".ingredients", :regex => /contains (\w+)/, :array => true},
                :ingredient_urls => {:css => ".references ol li",
                                     :block => lambda{|element| element.children.map{|child| child.attributes['href'].value if child.attributes['href']}.compact}
                                    }}
  end

  def self.attributes_with_string_keys
    attributes.each_with_object({}){|(k,v),h| h[k.to_s] = v.stringify_keys}
  end

  it_should_behave_like "Scrapify", Scrapify::Scraper.new(::Pizza.url, :name, attributes)
  it_should_behave_like "Scrapify", Scrapify::Scraper.new(::Pizza.url, 'name', attributes_with_string_keys)
end
