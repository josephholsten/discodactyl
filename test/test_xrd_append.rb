#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
testdir = File.expand_path('../../test', __FILE__)
$LOAD_PATH.unshift(testdir) unless $LOAD_PATH.include?(testdir)

require 'test_helper'
require "discodactyl/xrd/document"

class TestXRDAppendWithoutID < ::Test::Unit::TestCase
  def setup
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

    @xrd = Discodactyl::XRD::Document.parse(@full_xrd_string)
    @raw_link = '<Link rel="http://oexchange.org/spec/0.8/rel/user-target" type="application/xrd+xml" href="http://www.example.com/linkeater/oexchange.xrd"/>'
    @link = @xrd.append(@raw_link)
  end

  def test_inserts_link_in_raw
    assert_include? @link.raw, @xrd.raw.search('//xrd:Link', Discodactyl::XRD::XMLNS)
  end

  def test_append_preserves_rel
    assert_equal 'http://oexchange.org/spec/0.8/rel/user-target', @link.rel
  end

  def test_append_preserves_attributes
    assert_equal 'http://oexchange.org/spec/0.8/rel/user-target', @link.rel
    assert_equal 'application/xrd+xml', @link.type
    assert_equal 'http://www.example.com/linkeater/oexchange.xrd', @link.href
  end

  def test_append_preserves_attributes
    assert_equal 'http://oexchange.org/spec/0.8/rel/user-target', @link.rel
    assert_equal 'application/xrd+xml', @link.type
    assert_equal 'http://www.example.com/linkeater/oexchange.xrd', @link.href
  end
end
