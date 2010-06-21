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

  def test_links_by_rel
    links = @xrd.links_by_rel('feed')

    assert_length(1, links)
    expected = Discodactyl::URITemplate.new('http://host.example/descriptor?q={%id}')
    assert_equal(expected, links[0].template)
  end

  def test_uris_by_rel
    links = @xrd.uris_by_rel('feed', 'id' => 'dclinton@gmail.com')

    assert_length(1, links)
    assert_include?('http://host.example/descriptor?q=dclinton@gmail.com', links)
  end
end
