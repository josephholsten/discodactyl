require 'open-uri'
require 'nokogiri'
require 'active_support'
# uri = URI.parse "http://josephholsten.com/"
module XRD
  class ResourceDiscovery
    class << self
      def get_host_meta(host)
        host_meta_uri = 'http://'+ host + '/.well-known/host-meta'
        open(host_meta_uri)
      end

      # Not fully implemented yet!
      # any brilliant ideas about breaking this up are welcome
      def get_describedby_link(uri)
        # res = Net::HTTP.start(uri.host, uri.port){|http| http.request_get(uri.path)
        begin
          resource = open(uri)

          if resource.meta.key? 'Link'
            xrd = get_describedby_from_link_header(resource)
          else
            xrd = get_describedby_from_html(resource)
          end
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
          #   return get_describedby_link(uri)
          # elsif code == "301" || status == "302"
          # 300        HTTPMultipleChoice
          # 301        HTTPMovedPermanently
          # 302        HTTPFound
          # 304        HTTPNotModified
          # 305        HTTPUseProxy
          # 307        HTTPTemporaryRedirect
          #   return get_describedby_link(resource['location'])
          # else
          #   get_host_meta uri.host
        end
        xrd
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
          parse_link_header(link);
        }
        link = links.find {|l| l[:rel].include? rel }
        xrd = link[:href]
      end

      def parse_link_header(string)
        returning(params = {}) do
          if string =~ /^<([^>]+)>(.*)$/
            params[:href] = $1
            $2.split(/;\s*/).each do |part|
              param, value = part.split '='
              value = value[1...-1] if value =~ /^".*"$/
              if param =~ /rel/i
                  insert_name_into_hash(params, param.to_sym, value)
              elsif !param.nil?
                  params[param.to_sym] = value
              end
            end
          else
            raise "malformed link header: #{string}"
          end
        end
      end

      def insert_name_into_hash(hash, name, value)
          value = value.split(/\s+/)
          hash[name] ||= []
          hash[name] << value
          hash[name].flatten!
          hash
      end

    end
  end
end
