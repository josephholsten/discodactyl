require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "xrd"

class TestHostMeta < Test::Unit::TestCase
  def test_get_uri_from_host
    uri = 'host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, XRD::HostMeta.get_uri_from_uri(uri)
  end

  def test_get_uri_from_http
    uri = URI.parse 'http://host.example/some/path'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, XRD::HostMeta.get_uri_from_uri(uri)
  end

  def test_get_uri_from_acct
    uri = URI.parse 'acct:user@host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta'
    assert_equal expected, XRD::HostMeta.get_uri_from_uri(uri)
  end
end
