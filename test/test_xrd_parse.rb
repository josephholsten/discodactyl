require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "xrd"

class TestXRDParsing < Test::Unit::TestCase
  def test_parse
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">\n  <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject>\n  <Link>\n    <Rel>http://webfinger.info/rel/service</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n  <Link>\n    <Rel>describedby</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n</XRD>\n'
    doc = XRD::Document.parse(raw)
    assert_not_nil(doc)
  end
  def test_parse_links
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">\n  <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject>\n  <Link>\n    <Rel>http://webfinger.info/rel/service</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n  <Link>\n    <Rel>describedby</Rel>\n    <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate>\n  </Link>\n</XRD>\n'
    doc = XRD::Document.parse(raw)
    assert_equal(2, doc.links.length)
  end
  def test_links_by_rel
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"> <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject> <Link> <Rel>http://webfinger.info/rel/service</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> <Link> <Rel>describedby</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> </XRD>'
    doc = XRD::Document.parse(raw)

    rel = 'http://webfinger.info/rel/service'
    links = doc.links_by_rel(rel)

    assert_length(1, links)
    expected = URITemplate.new('http://www.google.com/s2/webfinger/?q={%id}')
    assert_include?(expected, links[0].uris)
  end
  def test_uris_by_rel
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"> <Subject match="http://docs.oasis-open.org/xri/xrd/v1.0#begins-with">http://gmail.com/</Subject> <Link> <Rel>http://webfinger.info/rel/service</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> <Link> <Rel>describedby</Rel> <URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate> </Link> </XRD>'
    doc = XRD::Document.parse(raw)

    rel = 'http://webfinger.info/rel/service'
    links = doc.uris_by_rel(rel, 'id' => 'dclinton@gmail.com')

    assert_length(1, links)
    assert_include?('http://www.google.com/s2/webfinger/?q=dclinton@gmail.com', links)
  end
end
