require 'open-uri'
require 'nokogiri'
require 'discodactyl/link_header'
require 'discodactyl/log'

module Discodactyl # :nodoc:
  class ResourceDiscovery
    class << self

      # perform LRDD on the URI, returning all linked URIs which match
      # the provided rel. Any URITemplates will be expanded with the
      # params if they are provided
      #--
      # TODO: xri support: no host
      # TODO: check if XRD/Property[@type=http://lrdd.net/priority/resource] to indicate resource-priority
      # TODO: handle 3** status redirects
      # TODO: maintain a security bit
      # TODO: URIs for all discovery modes should be appended, not just returned
      # TODO: rewrite this so it's just get links, which yields objects providing at least the xrd link interface (rel, href, type)
      #++
      def get_uris_by_rel(uri, rel, params = {})
        begin
          uri = URI.parse(uri.to_s) unless uri.respond_to?('open')
          Discodactyl.log.debug "Getting uris for uri #{uri.inspect} by rel #{rel.inspect} with params #{params.inspect}" if Discodactyl.log
          resource = uri.open
        rescue OpenURI::HTTPError => e
          status = e.io.status[0] # => 3xx, 4xx, or 5xx

          # code = Net::HTTPResponse::CODE_TO_OBJ[status]
          # if code == "303"
          # 303        HTTPSeeOther
          #   if res.key? 'Link'
          #     links = res['Link']
          #   end
          # elsif code == "401" # HTTPUnauthorized
          #   authenticate
          #   return get_uris_by_rel(uri)
          # elsif code == "301" || status == "302"
          # 300        HTTPMultipleChoice
          # 301        HTTPMovedPermanently
          # 302        HTTPFound
          # 304        HTTPNotModified
          # 305        HTTPUseProxy
          # 307        HTTPTemporaryRedirect
          #   resource = URI.parse(resource['location']).open
          # else
        rescue NoMethodError
        end
        if resource
          # check for link headers first
          if resource.meta.key? 'Link'
            uris = get_uris_by_rel_from_link_header(resource, rel)
          end

          unless uris
            # then check for links in the document
            if content_sniff(resource) == 'text/html'
              uris = get_uris_by_rel_from_html(resource, rel)
            # Atom
            elsif content_sniff(resource) == 'application/atom+xml'
              uris = get_uris_by_rel_from_atom(resource, rel)
            end
          end
        end
        unless uris
          Discodactyl.log.debug("getting jrd host-meta") if Discodactyl.log
          begin
            host_meta = Discodactyl::HostMetaJRD.from_uri uri
          rescue => error
            Discodactyl.log.debug("Error parsing jrd host-meta: #{error}") if Discodactyl.log
          end
          Discodactyl.log.debug("finding uris in jrd host-meta") if Discodactyl.log
          uris = host_meta.uris_by_rel(rel, params) if host_meta
        end
        
        unless uris
          Discodactyl.log.debug("Getting xrd host-meta") if Discodactyl.log
          begin
            host_meta = Discodactyl::HostMeta.from_uri uri
          rescue => error
            Discodactyl.log.debug("Error getting xrd host-meta: #{error}") if Discodactyl.log
            raise
          end
          Discodactyl.log.debug("finding uris in host-meta") if Discodactyl.log
          uris = host_meta.uris_by_rel(rel, params)
        end
        Discodactyl.log.debug "URIs: #{uris.inspect}" if Discodactyl.log
        uris
      end

      def lrdd_discovery(uri)
        get_uris_by_rel(uri, 'describedby')
      end

      def content_sniff(resource)
        if resource.content_type == 'text/html'
          type = 'text/html'
        elsif resource.content_type == 'application/atom+xml'
          type = 'application/atom+xml'
        end
        type
      end

      # take an HTTP response with a content-type of HTML,
      # find all links by rel, and return each href
      def get_uris_by_rel_from_html(resource, rel)
        doc = Nokogiri::HTML(resource)
        links = doc.xpath("//*[contains(@rel, \"#{rel}\")]")
        uris = links.map {|link| link['href'] }
      end

      # take an HTTP response, find a link header
      # with rel, and return its href
      def get_uris_by_rel_from_link_header(response, rel)
        links = [response.meta['Link']].flatten.collect {|link|
          LinkHeader.parse(link);
        }
        link = links.find {|l| l[:rel].include? rel }
        xrd = link[:href]
      end
    end
  end
end
