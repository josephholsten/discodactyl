require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "xrd"

class TestResourceDiscovery < Test::Unit::TestCase
  def test_get_uris_by_rel_from_html
    raw = '<html><head><title></title><link rel="describedby" href="http://host.example/description.xrd"></head><body></body></html>'

    uris = XRD::ResourceDiscovery.get_uris_by_rel_from_html(raw, 'describedby')

    assert_include? 'http://host.example/description.xrd', uris
  end

  def test_get_uris_by_rel_from_html_with_multiple_rels
    raw = '<html><head><title></title><link rel="also describedby" href="http://host.example/description.xrd"></head><body></body></html>'

    uris = XRD::ResourceDiscovery.get_uris_by_rel_from_html(raw, 'describedby')

    assert_include? 'http://host.example/description.xrd', uris
  end

  def test_get_uris_by_rel_from_link_header
    require 'ostruct'
    header = '<http://host.example/description.xrd>; rel="describedby"'
    response = OpenStruct.new(:meta => {'Link' => header})

    uris = XRD::ResourceDiscovery.get_uris_by_rel_from_link_header(response, 'describedby')

    assert_equal 'http://host.example/description.xrd', uris
  end
end
