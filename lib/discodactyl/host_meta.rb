require 'discodactyl/xrd'

module Discodactyl
  class HostMeta < XRD::Document
    class << self
      def get_uri_from_uri(uri)
        host = uri.respond_to?('host') ? uri.host : uri
        URI.parse('http://'+ host + '/.well-known/host-meta')
      end

      def from_uri(uri)
        raw = get_uri_from_uri(uri).open
        self.parse raw
      end
    end
  end
end
