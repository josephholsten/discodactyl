require 'open-uri'
require 'active_support'
require 'socket'
require "discodactyl/uri_template"
require "discodactyl/jrd"
require 'discodactyl/log'

module Discodactyl
  class HostMetaJRD < Discodactyl::JRD::Document
    # Take a URI and return the URI for its HostMeta document
    def self.get_uri_from_uri(uri)
      host = uri.respond_to?('host') ? uri.host : uri
      URI.parse('http://'+ host + '/.well-known/host-meta.json')
    end

    # Take a URI and retrieve its HostMeta document
    def self.from_uri(uri)
      uri = get_uri_from_uri(uri)
      Discodactyl.log.debug("got jrd host-meta uri: #{uri}") if Discodactyl.log
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
