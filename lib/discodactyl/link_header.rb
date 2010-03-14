require 'active_support/core_ext/object/misc'

module Discodactyl
  class LinkHeader < Hash
    class << self
      def parse(string)
        returning(params = LinkHeader.new) do
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
