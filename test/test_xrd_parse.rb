#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
testdir = File.expand_path('../../test', __FILE__)
$LOAD_PATH.unshift(testdir) unless $LOAD_PATH.include?(testdir)

require 'test_helper'
require "test/unit"
require "discodactyl/xrd/document"

class TestXRDParsing < Test::Unit::TestCase
  def setup
    @minimal_xrd_string =<<eos
<?xml version=\"1.0\"?>
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>http://host.example/</Subject>
</XRD>
eos

    @full_xrd_string =<<eos
<?xml version=\"1.0\"?>
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Subject>http://host.example/</Subject>
  <Link rel="webfinger" href="http://host.example/endpoint"/>
  <Link rel="describedby" href="http://host.example/endpoint"/>
  <Link rel="feed" template="http://host.example/descriptor?q={%id}"/>
  <Link rel="describedby" template="http://host.example/descriptor?q={%id}"/>
</XRD>
eos

    @raw_link_without_id = '<Link rel="http://oexchange.org/spec/0.8/rel/user-target" type="application/xrd+xml" href="http://www.example.com/linkeater/oexchange.xrd"/>'
    @raw_link_with_id = '<Link xml:id="foo" rel="http://oexchange.org/spec/0.8/rel/user-target" type="application/xrd+xml" href="http://www.example.com/linkeater/oexchange.xrd"/>'

    @xrd = Discodactyl::XRD::Document.parse(@full_xrd_string)
  end
  def test_parse
    doc = Discodactyl::XRD::Document.parse(@full_xrd_string)
    assert_not_nil(doc)
  end
  def test_parse_links
    assert_equal(4, @xrd.links.length)
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
    link_elems = @xrd.linkelems_by_rel 'describedby'

    assert_length(2, link_elems)

    assert_equal 'http://host.example/endpoint', link_elems[0]['href']
    assert_equal 'http://host.example/descriptor?q={%id}', link_elems[1]['template']
  end

  def test_linkelems_by_rel_with_multiple_rels
    link_elems = @xrd.linkelems_by_rel 'describedby'

    assert_length(2, link_elems)

    assert_equal 'http://host.example/endpoint', link_elems[0]['href']
    assert_equal 'http://host.example/descriptor?q={%id}', link_elems[1]['template']
  end

  def test_uris_by_rel
    uris = @xrd.uris_by_rel 'describedby', 'id' => 'bradfitz@gmail.com'

    assert_length(2, uris)

    assert_equal 'http://host.example/endpoint', uris[0]
    assert_equal 'http://host.example/descriptor?q=bradfitz@gmail.com', uris[1]
  end

  def test_to_s
    assert_equal @full_xrd_string, @xrd.to_s
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
