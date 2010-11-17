# require 'active_support/core_ext/object/misc'

module Discodactyl # :nodoc:
  # Access to web links stored in HTTP Link header-fields. See also: 
  # http://tools.ietf.org/html/draft-nottingham-http-link-header
  class LinkHeader < Hash
    class << self
      # Take the link header value as a string and parse it into a Hash
      #
      # For example, the raw link header
      #   Link: </>; rel="http://example.net/foo"
      # is parsed by saying
      #   link = LinkHeader.parse('</>; rel="http://example.net/foo"')
      #   link[:href] # '/'
      #   link[:rel] # ['http://example.net/foo']
      def parse(string)
        LinkHeader.new.tap do |params|
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

    private
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
