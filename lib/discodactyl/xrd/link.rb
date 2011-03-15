require 'nokogiri'
require 'discodactyl/uri_template'

module Discodactyl # :nodoc:
module XRD # :nodoc:
  class Link < Struct.new(:href, :template, :rel, :title, :type)
    attr_accessor :raw
    class << self
      def parse(element)
        self.new.tap do |link|
          link.rel = element['rel']
          link.type = element['type']
          link.href = element['href']
          link.title = element['title']
          link.template = URITemplate.new(element['template']) unless link.href
          link.raw = element
        end
      end
    end

    def to_uri(params = {})
      href || template.to_uri(params)
    end

    def id
      begin
        @raw.attribute_with_ns('id', 'http://www.w3.org/XML/1998/namespace').value
      rescue
      end
    end

    def id=(value)
      @raw['xml:id'] = value
    end

    def to_s
      @raw.to_s
    end

    def ==(other)
      (other.respond_to?('raw') && (@raw == other.raw)) ||
      super
    end
  end
end
end
