require 'nokogiri'
require 'active_support/core_ext/object/misc'
require 'discodactyl/uri_template'

module Discodactyl
module XRD
  class Link
    class << self
      def parse(element)
        returning(link = self.new) do
          link.rel = element['rel']
          link.type = element['type']
          link.href = element['href']
          link.template = URITemplate.new(element['template']) unless link.href
        end
      end
    end
    attr_accessor :href, :template, :rel, :type
    def to_uri(params = {})
      @href || @template.to_uri(params)
    end
  end
end
end
