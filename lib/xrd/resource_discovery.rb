require 'open-uri'
require 'nokogiri'
require 'active_support'
# uri = URI.parse "http://josephholsten.com/"
module XRD
  class ResourceDiscovery
    def self.get_describedby_link(uri)
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
        #   #get site meta link
      end
      xrd
    end
    
    # take an HTTP response, find a link header
    # with rel=describedby, and return its href
    def get_describedby_from_link_header(response)
      links = [response['Link']].flatten.collect {|link|
        parse_link_header(link);
      }
      link = links.find {|l| l[:rel].include? 'describedby' }
      xrd = link[:href]
    end
    
    # take an HTTP response with a content-type of HTML,
    # find a link with rel=describedby, and return its href
    def self.get_describedby_from_html(resource)
      doc = Nokogiri::HTML(resource)
      link = doc.xpath('//*[@rel="describedby"]').first
      xrd = link['href']
    end

    def self.parse_link_header(string)
      returning(params = {}) do
        if string =~ /^Link:\s*<([^>]+)>(.*)$/
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
    
    def self.insert_name_into_hash(hash, name, value)
        value = value.split(/\s+/)
        hash[name] ||= []
        hash[name] << value
        hash[name].flatten!
        hash
    end
  end
end