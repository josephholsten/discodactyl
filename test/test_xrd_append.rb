#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
testdir = File.expand_path('../../test', __FILE__)
$LOAD_PATH.unshift(testdir) unless $LOAD_PATH.include?(testdir)

require 'test_helper'
require 'discodactyl/xrd/document'

module Discodactyl
class XRDTestCase < ::Test::Unit::TestCase   #:nodoc:
  # Placeholder so test/unit ignores test cases without any tests.
  def default_test
  end
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
  end
end
end

class TestXRDAppendWithId < Discodactyl::XRDTestCase
  def setup
    super
    @raw_link = '<Link xml:id="foo" rel="http://oexchange.org/spec/0.8/rel/user-target" type="application/xrd+xml" href="http://www.example.com/linkeater/oexchange.xrd"/>'    
    @link = @xrd.append(@raw_link)
  end

  def test_append_with_id_does_not_overwrite
    assert_equal @raw_link, @link.to_s
  end

  def test_append_generates_id_on_duplicate
    second = @xrd.append(@raw_link)
    assert_not_equal @link.id, second.id
  end
end

class TestXRDAppendWithoutID < Discodactyl::XRDTestCase
  def setup
    super
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

  def test_inserts_link
    assert_include? @link, @xrd.links
  end

  def test_generates_id
    assert_not_nil @link.id
    assert !@link.id.empty?
  end

  def test_can_find_appended_link_by_returned_link_id
    actual = @xrd.find_link_by_id(@link.id)

    assert_equal 'http://oexchange.org/spec/0.8/rel/user-target', actual.rel
    assert_equal 'application/xrd+xml', actual.type
    assert_equal 'http://www.example.com/linkeater/oexchange.xrd', actual.href
  end
end

