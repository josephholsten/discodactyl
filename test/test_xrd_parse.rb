#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "discodactyl"

class TestXRDParsing < Test::Unit::TestCase
  def test_parse
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">\n  <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject>\n  <Link>\n    <Rel>http://webfinger.info/rel/service</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n  <Link>\n    <Rel>describedby</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n</XRD>\n'
    doc = Discodactyl::XRD::Document.parse(raw)
    assert_not_nil(doc)
  end
  def test_parse_links
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">\n  <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject>\n  <Link>\n    <Rel>http://webfinger.info/rel/service</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n  <Link>\n    <Rel>describedby</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n</XRD>\n'
    doc = Discodactyl::XRD::Document.parse(raw)
    assert_equal(2, doc.links.length)
  end

#  def test_xpath_escape
#    doc = Nokogiri('<root><node>foo\'bar"baz</node></root>').xpath('/root[node=\'foo&apos;bar&quot;baz\']')
#	assert_length(1, actual)
#  end

#  def test_linkelems_by_rel_escaping_for_apos
#    doc = Discodactyl::XRD::Document.parse <<eos
#<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
#  <Subject>http://host.example/</Subject>
#  <Link>
#	<Rel>foo'bar</Rel>
#	<URI>http://host.example/endpoint</URI>
#  </Link>
# </XRD>
#eos
#
#	link_elems = doc.linkelems_by_rel "foo'bar"
#
#    assert_length(1, link_elems)
#
#	ns = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
#	uri = link_elems[0].xpath('./xrd:URI', ns)
#	assert_equal('http://host.example/endpoint', uri.text)
#  end

  def test_linkelems_by_rel
    doc = Discodactyl::XRD::Document.parse <<eos
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>http://host.example/</Subject>
  <Link>
	<Rel>describedby</Rel>
	<URI>http://host.example/endpoint</URI>
  </Link>
  <Link>
	<Rel>describedby</Rel>
	<URITemplate>http://host.example/descriptor?q={%id}</URITemplate>
  </Link>
 </XRD>
eos

	link_elems = doc.linkelems_by_rel 'describedby'

    assert_length(2, link_elems)

	ns = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
	uri = link_elems[0].xpath('./xrd:URI', ns)
	assert_equal('http://host.example/endpoint', uri.text, "First Link URI")

	template = link_elems[1].xpath('./xrd:URITemplate', ns)
	assert_equal('http://host.example/descriptor?q={%id}', template.text, "Second link URITemplate")
  end

  def test_linkelems_by_rel_with_multiple_rels
    doc = Discodactyl::XRD::Document.parse <<eos
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>http://host.example/</Subject>
  <Link>
	<Rel>webfinger</Rel>
	<Rel>describedby</Rel>
	<URI>http://host.example/endpoint</URI>
  </Link>
  <Link>
	<Rel>feed</Rel>
	<Rel>describedby</Rel>
	<URITemplate>http://host.example/descriptor?q={%id}</URITemplate>
  </Link>
 </XRD>
eos

	link_elems = doc.linkelems_by_rel 'describedby'

    assert_length(2, link_elems)

	ns = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
	uri = link_elems[0].xpath('./xrd:URI', ns)
	assert_equal('http://host.example/endpoint', uri.text, "First Link URI")

	template = link_elems[1].xpath('./xrd:URITemplate', ns)
	assert_equal('http://host.example/descriptor?q={%id}', template.text, "Second link URITemplate")
  end

  def test_urielems_by_rel_with_multiple_rels
    doc = Discodactyl::XRD::Document.parse <<eos
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>http://host.example/</Subject>
  <Link>
	<Rel>webfinger</Rel>
	<Rel>describedby</Rel>
	<URI>http://host.example/endpoint</URI>
	<URITemplate>http://node.example/descriptor?q={%id}</URITemplate>
  </Link>
  <Link>
	<Rel>feed</Rel>
	<Rel>describedby</Rel>
	<URITemplate>http://host.example/descriptor?q={%id}</URITemplate>
	<URI>http://node.example/endpoint</URI>
  </Link>
 </XRD>
eos

	uri_elems = doc.urielems_by_rel 'describedby'

    assert_length(4, uri_elems, 'got uri_elems: [[[%s]]]'%uri_elems.to_s)

	assert_equal('http://host.example/endpoint', uri_elems[0].text)
	assert_equal('http://node.example/descriptor?q={%id}', uri_elems[1].text)
	assert_equal('http://host.example/descriptor?q={%id}', uri_elems[2].text)
	assert_equal('http://node.example/endpoint', uri_elems[3].text)
  end

#  def test_links_by_rel
#    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"> <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject> <Link> <Rel>http://webfinger.info/rel/service</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> <Link> <Rel>describedby</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> </XRD>'
#    doc = Discodactyl::XRD::Document.parse(raw)
#
#    rel = 'http://webfinger.info/rel/service'
#    links = doc.links_by_rel(rel)
#
#    assert_length(1, links)
#    expected = URITemplate.new('http://www.google.com/s2/webfinger/?q={%id}')
#    assert_include?(expected, links[0].uris)
#  end
#  def test_uris_by_rel
#    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"> <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject> <Link> <Rel>http://webfinger.info/rel/service</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> <Link> <Rel>describedby</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> </XRD>'
#    doc = Discodactyl::XRD::Document.parse(raw)
#
#    rel = 'http://webfinger.info/rel/service'
#    links = doc.uris_by_rel(rel, 'id' => 'dclinton@gmail.com')
#
#    assert_length(1, links)
#    assert_include?('http://www.google.com/s2/webfinger/?q=dclinton@gmail.com', links)
#  end
end
