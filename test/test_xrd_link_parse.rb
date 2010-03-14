#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "discodactyl"

class TestXRDLinkParsing < Test::Unit::TestCase
  def setup
    @namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
  end
  def test_parse_all
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><MediaType>text/html</MediaType><Rel>http://webfinger.info/rel/service</Rel><URI>http://host.example</URI><URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_not_nil(link)
    assert_length(1, link.rels)
    assert_include?('http://webfinger.info/rel/service', link.rels)
    assert_length(1, link.media_types)
    assert_include?('text/html', link.media_types)
    assert_length(2, link.uris)
    assert_include?('http://host.example', link.uris)
    assert_include?(URITemplate.new('http://www.google.com/s2/webfinger/?q={%id}'), link.uris)
  end

  def test_parse_empty
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_not_nil(link)
  end

  def test_parse_rels
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><Rel>http://webfinger.info/rel/service</Rel></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_length(1, link.rels)
    assert_include?('http://webfinger.info/rel/service', link.rels)
  end

  def test_parse_media_types
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><MediaType>text/html</MediaType></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_length(1, link.media_types)
    assert_include?('text/html', link.media_types)
  end

  def test_parse_uris
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><URI>http://host.example</URI></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_length(1, link.uris)
    assert_include?('http://host.example', link.uris)
  end

  def test_parse_uri_templates
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_length(1, link.uris)
    assert_include?(URITemplate.new('http://www.google.com/s2/webfinger/?q={%id}'), link.uris)
  end

  def test_to_uris_for_mixed_uris_and_uri_templates
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><URI>http://host.example</URI><URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    uris = link.to_uris 'id' => 'bob@gmail.com'

    assert_length(2, uris)
    assert_include?('http://host.example', uris)
    assert_include?('http://www.google.com/s2/webfinger/?q=bob@gmail.com', uris)
  end

  def test_to_uris_for_plain_uri
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><URI>http://host.example</URI></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    uris = link.to_uris

    assert_length(1, uris)
    assert_include?('http://host.example', uris)
  end

  def test_to_uris_for_uri_template
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    uris = link.to_uris 'id' => 'bob@gmail.com'

    assert_length(1, uris)
    assert_include?('http://www.google.com/s2/webfinger/?q=bob@gmail.com', uris)
  end

  def test_has_media_type?
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><MediaType>text/html</MediaType></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    assert_has_media_type?(link, 'text/html')
  end

  def test_has_rel?
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link><Rel>http://webfinger.info/rel/service</Rel><URITemplate>http://www.google.com/s2/webfinger/?q={%id}</URITemplate></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    assert_has_rel?(link, 'http://webfinger.info/rel/service')
  end

  def assert_has_media_type?(link, media_type, message = nil)
    message = build_message message, '<?> does not have the media_type <?>.', link, media_type
    assert link.has_media_type?(media_type), message
  end

  def assert_has_rel?(link, rel, message = nil)
    message = build_message message, '<?> does not have the rel <?>.', link, rel
    assert link.has_rel?(rel), message
  end
end
