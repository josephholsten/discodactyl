#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl/host_meta"
require "discodactyl/acct_uri"

class TestHostMeta < Test::Unit::TestCase
  def test_get_uri_from_host
    uri = 'host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, Discodactyl::HostMeta.get_uri_from_uri(uri)
  end

  def test_get_uri_from_http
    uri = URI.parse 'http://host.example/some/path'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, Discodactyl::HostMeta.get_uri_from_uri(uri)
  end

  def test_get_uri_from_acct
    uri = URI.parse 'acct:user@host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, Discodactyl::HostMeta.get_uri_from_uri(uri)
  end

  # def test_raise_meaningful_exception
  #   stub(io).status { [ '404', 'Not Found'] }
  #   stub(uri).open { raise OpenURI::HTTPError.new('foo', io)}
  #   stub(URI).parse('http://example.com/.well-known/host-meta') { uri }
  #
  #   assert_raise Discodactyl::HostMetaHTTPError, "404 Not Found" do
  #     Discodactyl::HostMeta.from_uri(uri)
  #   end
  # end
end
