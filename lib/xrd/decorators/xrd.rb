require 'nokogiri'

module XRD
  module Decorators
    module Document
      def find_subject_certificate
        require 'base64'
        require 'openssl'
        namespaces = {
          'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0",
          'ds' => 'http://www.w3.org/2000/09/xmldsig#'
        }
        path = '/xrd:XRD/xrd:KeyDescriptor/ds:KeyInfo/ds:X509Data/ds:X509Certificate'
        cert_elem = @doc.xpath(path, namespaces)
        cert_str = Base64::decode64(cert_elem.text)
        OpenSSL::X509::Certificate.new(cert_str)
      end
    
      def find_links
        namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
        path = '/xrd:XRD/xrd:Link'
        return self.xpath(path, namespaces)
      end
      def find_links_by_rel(rel)
      
      end
      def subject
        namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
        return self.xpath('/xrd:XRD/xrd:Subject', namespaces)
      end
    end
  end
end