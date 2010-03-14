#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
testdir = File.expand_path('../../test', __FILE__)
$LOAD_PATH.unshift(testdir) unless $LOAD_PATH.include?(testdir)

require 'test_helper'
require "test/unit"
require "discodactyl"

class TestXRDLinkParsing < Test::Unit::TestCase
  def setup
    @namespaces = {'xrd' => "http://docs.oasis-open.org/ns/xri/xrd-1.0"}
  end
  def test_parse_all
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link rel="lrdd" type="text/html" href="http://host.example" template="http://www.google.com/s2/webfinger/?q={%id}"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal 'lrdd', link.rel
    assert_equal 'text/html', link.type
    assert_equal 'http://host.example', link.href
    assert_nil link.template
  end

  def test_parse_empty
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link></Link></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_not_nil(link)
  end

  def test_parse_rel
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link rel="lrdd"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal 'lrdd', link.rel
  end

  def test_parse_type
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link type="text/html"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal 'text/html', link.type
  end

  def test_parse_href
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link href="http://host.example"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal 'http://host.example', link.href
  end

  def test_parse_template
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link template="http://www.google.com/s2/webfinger/?q={%id}"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal URITemplate.new('http://www.google.com/s2/webfinger/?q={%id}'), link.template
  end

  def test_ignores_template_when_href_exists
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link rel="lrdd" type="text/html" href="http://host.example" template="http://www.google.com/s2/webfinger/?q={%id}"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first

    link = Discodactyl::XRD::Link.parse(elem)

    assert_equal 'http://host.example', link.href
    assert_nil link.template
  end

  def test_to_uris_for_plain_uri
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link href="http://host.example"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    uri = link.to_uri

    assert_equal 'http://host.example', uri
  end

  def test_to_uris_for_uri_template
    raw = '<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0"><Link template="http://www.google.com/s2/webfinger/?q={%id}"/></XRD>'
    elem = Nokogiri(raw).xpath('/xrd:XRD/xrd:Link', @namespaces).first
    link = Discodactyl::XRD::Link.parse(elem)

    uri = link.to_uri 'id' => 'bob@gmail.com'

    assert_equal 'http://www.google.com/s2/webfinger/?q=bob@gmail.com', uri
  end
end
