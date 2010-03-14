require 'nokogiri'
require 'discodactyl/xrd/link'

module Discodactyl
module XRD
  class Document
    class << self
      def parse(string)
        raw = Nokogiri::XML(string)
        doc = self.new

        namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
        link_elems = raw.xpath('/xrd:XRD/xrd:Link', namespaces)
        doc.links = link_elems.collect {|elem|
          Link.parse(elem)
        }

        doc.raw = raw

        doc
      end
    end
    attr_accessor :links, :raw
    # attr_accessor :expires, :links, :subject, :aliases
	def escapeXPath(str)
      inner = str.split('\'').join('\',"\'",\'')
	  outer = 'concat(\'\',\'%s\')' % inner
	end
    def linkelems_by_rel(rel)
      namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
      path = "/xrd:XRD/xrd:Link[@rel=%s]"% escapeXPath(rel)
      @raw.xpath path, namespaces
    end
    def links_by_rel(rel)
      linkelems_by_rel(rel).map {|e| Link.parse(e) }
    end
    # def links_by_media_type(media_type)
    #   links.collect{|l| l.has_media_type? media_type }
    # end
    def uris_by_rel(rel, params = {})
        links_by_rel(rel).map {|l| l.to_uri(params) }
    end
    # def uris_by_media_type(media_type, params = {})
    #   links_by_media_type(media_type).collect{|l| l.to_uris params }.flatten
    # end
    def to_s
      raw.to_s
    end
  end
end
end
