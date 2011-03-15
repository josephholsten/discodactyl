require 'discodactyl/uri_template'

module Discodactyl # :nodoc:
module JRD # :nodoc:
  class Link < Struct.new(:href, :template, :rel, :title, :type)
    attr_accessor :raw
    class << self
      def parse(element)
        self.new.tap do |link|
          begin
            link.rel = element['rel']
            link.type = element['type']
            link.href = element['href']
            link.title = element['title']
            link.template = URITemplate.new(element['template']) unless link.href
            link.raw = element
          rescue
            raise "Couldn't parse #{link} into a JRD Link"
          end
        end
      end
    end
  end
end
end