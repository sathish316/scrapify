module Scrapify
  module Base
    HTTP_CACHE_HEADERS_TO_RETURN = %w(Cache-Control Last-Modified Age ETag)
    def self.included(klass)
      klass.extend ClassMethods
      klass.cattr_accessor :url, :doc, :attribute_names
      klass.instance_eval { attr_reader :attributes }
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(method, *args, &block)
      @attributes[method] || super
    end

    def to_json(*args)
      @attributes.to_json(*args)
    end

    module ClassMethods
      def html(url)
        self.url = url
        define_finders
      end

      def attribute(name, options={})
        add_attribute(name)
        parser = options[:xpath] ? :xpath : :css
        selector = options[parser]
        matcher = /#{options[:regex]}/ if options[:regex]
        to_array = options[:array]
        meta_define "#{name}_values" do
          self.doc ||= parse_html
          self.doc.send(parser, selector).map do |element|
            content = element.content
            if matcher
              match_data = content.scan(matcher).map &:first
              options[:array] ? match_data : match_data.first
            else
              content.strip
            end
          end
        end
      end

      def key(attribute)
        define_find_by_id attribute
        define_count attribute
      end

      def http_cache_header
        http_header.select do |(k, v)|
          HTTP_CACHE_HEADERS_TO_RETURN.map(&:upcase).include?(k.upcase)
        end
      end

      private

      def add_attribute(name)
        self.attribute_names ||= [] 
        self.attribute_names << name
      end

      def parse_html
        Nokogiri::HTML(html_content)
      end

      def html_content
        http_response.body
      end

      def http_response
        @http_response ||= Net::HTTP.get_response URI(url)
      end

      def http_header
        http_response.header.to_hash.each_with_object({}) do |(k,v), hash|
          hash[k] = v.first
        end
      end

      def define_finders
        meta_define :all do
          count.times.map do |index|
            find_by_index index
          end
        end

        meta_define :first do
          find_by_index 0
        end

        meta_define :last do
          find_by_index count - 1
        end

        meta_define :find_by_index do |index|
          return if index.nil? or index < 0
          attributes = Hash[attribute_names.map {|attribute| [attribute, send("#{attribute}_values")[index]]}]
          self.new(attributes)
        end
      end

      def define_count(key_attribute)
        meta_define :count do
          send("#{key_attribute}_values").size
        end
      end

      def define_find_by_id(key_attribute)
        meta_define :find do |key_value|
          index = send("#{key_attribute}_values").index(key_value)
          find_by_index index
        end
      end
    end
  end
end
