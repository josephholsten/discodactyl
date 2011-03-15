require 'discodactyl/xrd'
require 'open-uri'
require 'socket'

module Discodactyl # :nodoc
  # Convienient access to host metadata and individual resources controlled by 
  # the host. See also: http://tools.ietf.org/html/draft-hammer-hostmeta
  class HostMeta < XRD::Document
    class << self
      # Take a URI and return the URI for its HostMeta document
      def get_uri_from_uri(uri)
        host = uri.respond_to?('host') ? uri.host : uri
        URI.parse('http://'+ host + '/.well-known/host-meta')
      end

      # Take a URI and retrieve its HostMeta document
      def from_uri(uri)
        uri = get_uri_from_uri(uri)
        Discodactyl.log.debug("got xrd host-meta uri: #{uri}") if Discodactyl.log
        begin
          raw = uri.open
        rescue OpenURI::HTTPError => error
          if error.io.status[1] == 'Not Found'
            error.io.base_uri = uri
            raise HostMetaHTTPError.new(error.message, error.io)
          else
            raise
          end
        rescue ::SocketError => error
          raise HostMetaSocketError.new(error.message, uri.host, uri.port)
        end
        self.parse raw
      end
    end
  end
  class HostMetaHTTPError < OpenURI::HTTPError # :nodoc:
  end
  class HostMetaSocketError < StandardError # :nodoc:
    attr_accessor :host, :port
    def initialize(msg = nil, host = nil, port = nil)
      message = msg
      @host = host
      @port = port
    end
  end
end
