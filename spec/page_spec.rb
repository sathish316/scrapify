require 'spec_helper'
require 'test_models'

describe Scrapify::Page do
  attributes = {:name => {:css => ".menu_lft li a"},
                :image_url => {:xpath => "//li//input//@value"},
                :price => {:css => ".price", :regex => /([\d\.]+)/},
                :ingredients => {:css => ".ingredients", :regex => /contains (\w+)/, :array => true},
                :ingredient_urls => {:css => ".references ol li",
                                     :block => lambda{|element| element.children.map{|child| child.attributes['href'].value if child.attributes['href']}.compact}
                                    }
              }
  it_should_behave_like "Scrapify", Scrapify::Page.new(::Pizza.url, :name, attributes)
end
