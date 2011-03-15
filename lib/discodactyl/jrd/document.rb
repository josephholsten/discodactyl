require 'nokogiri'
require 'active_support'
require 'discodactyl/jrd/link'
require "discodactyl/uri_template"

module Discodactyl # :nodoc:
module JRD # :nodoc:
  class Document < Hash
    def self.parse(raw)
      begin
        Discodactyl.log.debug("parsing jrd: #{raw}") if Discodactyl.log
        decoded = ActiveSupport::JSON.decode(raw)
      rescue => e
        raise ParseError.new(e.message)
      end
      self.[](decoded)
    end

    def uris_by_rel(rel, params={})
      links_by_rel(rel).map do |link|
        link.href || link.template.to_uri(params)
      end
    end
    
    def links_by_rel(rel)
      if self.has_key? 'links' and self['links'].has_key? rel
        self['links'][rel].map{|link| Link.parse(link.merge('rel'=>rel)) }
      else
        []
      end
    end
    
    def links
      rels.map do |rel, links|
        links.map {|link| Link.parse(link.merge('rel' => rel)) }
      end.flatten
    end

    def rels
      self['links'] || []
    end
    
    def subject
      self['subject']
    end
  end
  class ParseError < StandardError; end
end
end