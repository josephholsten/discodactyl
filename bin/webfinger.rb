#!/usr/bin/env ruby -w
libdir = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'rubygems'
require 'lib/xrd'
require 'open-uri'

if ARGV.length == 0
	puts "Usage: #{__FILE__} user@host"
	exit 0
end

# parse identifier
acct = AcctURI.parse(ARGV[0])

# retrieve host-meta from host
host_meta_res = XRD::ResourceDiscovery.get_host_meta acct.host

# parse host_meta_doc
host_meta_doc = XRD::Document.parse host_meta_res

# Get linked URIs and URITemplates with the webfinger relation
finger_rel = "http://webfinger.info/rel/service"
webfinger_uris = host_meta_doc.uris_by_rel(finger_rel, 'id' => acct.to_s)

# retrieve user disco doc
disco_res = open(webfinger_uris.first)

# parse disco doc
###
# XRD::Documents are ugly at the moment
# reverting to standard XML in the meantime
###
#disco_doc = XRD::Document.parse disco_res
disco_doc = Nokogiri disco_res

# pretty print
puts disco_doc
