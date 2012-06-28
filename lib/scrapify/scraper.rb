module Scrapify
  class Scraper
    def initialize(url, key_attr, attributes)
      @scraper = Class.new
      @scraper.send(:include, Scrapify::Base)
      @scraper.html url
      @scraper.key key_attr.to_sym
      attributes.symbolize_keys.each do |attr, options|
        options = options.symbolize_keys
        custom_block = options.delete(:block)
        @scraper.attribute attr, options, &custom_block
      end
    end

    def method_missing(method, *args, &block)
      return @scraper.send(method, *args, &block) if @scraper.respond_to?(method)
      super
    end

    def respond_to?(method, include_private=false)
      @scraper.respond_to?(method, include_private) || super
    end
  end
end
