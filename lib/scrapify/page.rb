module Scrapify
  class Page
    def initialize(url, key_attr, attributes)
      klass = Class.new
      klass.send(:include, Scrapify::Base)
      klass.html url
      klass.key key_attr
      attributes.each do |attr, options|
        custom_block = options.delete(:block)
        klass.attribute attr, options, &custom_block
      end
      @klass = klass
    end

    def method_missing(method, *args, &block)
      return @klass.send(method, *args, &block) if @klass.respond_to?(method)
      super
    end

    def respond_to?(method, include_private=false)
      @klass.respond_to?(method, include_private) ||super
    end
  end
end
