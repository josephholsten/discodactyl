require 'nokogiri'

module Discodactyl
module XRD
  class Document
    class << self
      def parse(string)
        raw = Nokogiri(string)
        doc = self.new

        namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
        link_elems = raw.xpath('/xrd:XRD/xrd:Link', namespaces)
        doc.links = link_elems.collect {|elem|
          XRD::Link.parse(elem)
        }

        doc
      end
    end
    attr_accessor :links
    # attr_accessor :expires, :links, :subject, :aliases
    def links_by_rel(rel)
      @links.select{|l| l.has_rel? rel }
    end
    # def links_by_media_type(media_type)
    #   links.collect{|l| l.has_media_type? media_type }
    # end
    def uris_by_rel(rel, params = {})
        links_by_rel(rel).collect{|l| l.to_uris params }.flatten
    end
    # def uris_by_media_type(media_type, params = {})
    #   links_by_media_type(media_type).collect{|l| l.to_uris params }.flatten
    # end
  end
end
end
