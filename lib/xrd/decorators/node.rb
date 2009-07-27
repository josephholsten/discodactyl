require 'nokogiri'

module XRD
  module Node
  end
  
  module Link
    def rels
      namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
      self.xpath('./xrd:Rel', namespaces)
    end
    def uris
      namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
      self.xpath('./xrd:URI', namespaces)
    end
    def include_rel?(rel)
      rels.any? {|rel|
        rel.text == rel
      }
    end
  end
  module Rel
    def to_uri
      require 'uri'
      URI.parse self.text
    end
  end
  module URI
    def to_uri
      require 'uri'
      URI.parse self.text
    end
  end
end
