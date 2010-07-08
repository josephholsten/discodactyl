require 'nokogiri'
require 'active_support/core_ext/object/misc'
require 'discodactyl/uri_template'

module Discodactyl # :nodoc:
module XRD # :nodoc:
  class Link
    class << self
      def parse(element)
        returning(link = self.new) do
          link.rel = element['rel']
          link.type = element['type']
          link.href = element['href']
          link.template = URITemplate.new(element['template']) unless link.href
          link.raw = element
        end
      end
    end

    attr_accessor :href, :template, :rel, :type, :raw

    def to_uri(params = {})
      @href || @template.to_uri(params)
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
