#!/usr/bin/env ruby -w
libdir = File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'rubygems'
require 'lib/discodactyl'
require 'open-uri'

if ARGV.length == 0
	puts "Usage: #{__FILE__} user@host"
	exit 0
end

# parse identifier
acct = URI::ACCT.parse(ARGV[0])

# Perform LRDD discovery on acct with the  webfinger relation
finger_rel = "http://webfinger.info/rel/service"
webfinger_uris = Discodactyl::ResourceDiscovery.get_uris_by_rel(acct, finger_rel, 'id' => acct.id)

raise "URI didn't have any linked webfinger URIs" if webfinger_uris.empty?

# retrieve user disco doc
require 'prettyprint'
disco_res = open(webfinger_uris.first)

# parse disco doc
###
# XRD::Documents are ugly at the moment
# reverting to standard XML in the meantime
###
#disco_doc = Discodactyl::XRD::Document.parse disco_res
disco_doc = Nokogiri::XML disco_res

# pretty print
puts disco_doc
