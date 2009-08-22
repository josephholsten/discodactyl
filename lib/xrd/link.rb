require 'nokogiri'

module XRD
  class Link
    class << self
      def parse(element)
        link = self.new
        namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}

        link.rels =  map_texts(element, '//xrd:Rel', namespaces)
        link.media_types =  map_texts(element, '//xrd:MediaType', namespaces)
        link.uris =  map_texts(element, '//xrd:URI', namespaces)
        link.uris = link.uris + element.xpath('//xrd:URITemplate', namespaces).map {|elem|
          URITemplate.new elem.text
        }
        link
      end
      def map_texts(element, path, namespaces)
        element.xpath(path, namespaces).map {|elem| elem.text }
      end
    end
    attr_accessor :uris, :rels, :media_types
    def has_rel?(rel)
      @rels.include? rel
    end
    def has_media_type?(media_type)
      @media_types.include? media_type
    end
    def to_uris(params = {})
      @uris.collect{|u| u.respond_to?('to_uri') ? u.to_uri(params) : u }
    end
  end
end
