require 'nokogiri'
require 'discodactyl/xrd/link'

module Discodactyl # :nodoc:
module XRD # :nodoc:
  XMLNS = {'xrd' => 'http://docs.oasis-open.org/ns/xri/xrd-1.0'}
  class Document
    class << self
      def parse(string)
        raw = Nokogiri::XML(string)
        Discodactyl.log.debug("parsing xrd: #{raw}") if Discodactyl.log
        doc = self.new

        doc.raw = raw

        doc
      end
    end

    attr_accessor :raw

    def escapeXPath(str)
      inner = str.split('\'').join('\',"\'",\'')
      outer = 'concat(\'\',\'%s\')' % inner
    end

    def linkelems_by_rel(rel)
      path = '/xrd:XRD/xrd:Link[@rel=%s]'% escapeXPath(rel)
      @raw.xpath path, XMLNS
    end

    def links_by_rel(rel)
      # linkelems_by_rel(rel).map {|e| Link.parse(e) }
      find_all_links_by_rel(rel)
    end

    def uris_by_rel(rel, params = {})
      links_by_rel(rel).map {|l| l.to_uri(params) }
    end

    # take an XML fragment for a link and append it to the document
    def append(link)
      initial_ids = ids
      raw.root.add_child(link)
      elem = Link.parse(raw.root.last_element_child)
      elem.id = generate_tag_uri if elem.id.nil? || initial_ids.include?(elem.id)
      elem
    end

    def links
      raw.xpath('/xrd:XRD/xrd:Link', XMLNS).collect {|elem|
        Link.parse(elem)
      }
    end

    def find_link_by_id(link_id)
        links.find {|link| link.id == link_id}
    end
    
    def find_all_links_by_rel(rel)
        links.find_all {|link| link.rel == rel }
    end

    def ids
      links.map(&:id).reject(&:nil?)
    end

    def to_s
      raw.to_s
    end
    
    def rels
      links.map(&:rel).reject(&:nil?).uniq
    end

    def generate_tag_uri
      scheme = 'tag'
      authority = 'dactylo.us'
      date = Date.today.to_s
      specific = "/xrd/link/#{rand(2**10)}"
      "#{scheme}:#{authority},#{date}:#{specific}"
    end
    
    def subject
      raw.xpath('/xrd:XRD/xrd:Subject', XMLNS).text
    end
  end
end
end
