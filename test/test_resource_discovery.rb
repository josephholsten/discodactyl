require File.dirname(__FILE__) + '/test_helper'
require "test/unit"
require "xrd"

class TestResourceDiscovery < Test::Unit::TestCase
  def test_retrieve_remote_xrd
    uri = 'http://josephholsten.com'
    expected = 'http://josephholsten.com/descriptor.xrd'
    assert_equal expected, XRD::ResourceDiscovery.get_describedby_link(uri)
  end
  
  # def test_parse_link_header
  #   link = '<http://josephholsten.com/descriptor.xrd>; rel="describedby"; type="application/xrd+xml"'
  #   expected = {
  #     :content => 'http://josephholsten.com/descriptor.xrd',
  #     :rel => 'describedby',
  #     :type => 'application/xrd+xml'
  #   }
  #   assert_equal(expected, get_link(link))
  # end
  
  # def test_get_site_meta
  # end
end