require 'discodactyl/xrd'
require 'open-uri'

module Discodactyl
  class HostMeta < XRD::Document
    class << self
      def get_uri_from_uri(uri)
        host = uri.respond_to?('host') ? uri.host : uri
        URI.parse('http://'+ host + '/.well-known/host-meta')
      end

      def from_uri(uri)
        uri = get_uri_from_uri(uri)
        begin
          raw = uri.open
        rescue OpenURI::HTTPError => error
          if error.io.status[1] == 'Not Found'
            error.io.base_uri = uri
            raise HostMetaHTTPError.new(error.message, error.io)
          else
            raise
          end
        end
        self.parse raw
      end
    end
  end
  class HostMetaHTTPError < OpenURI::HTTPError; end
end
