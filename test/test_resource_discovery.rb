require "test/unit"
require "xrd"

class TestResourceDiscovery < Test::Unit::TestCase
  def test_retrieve_remote_xrd
    uri = 'http://josephholsten.com'
    expected = 'http://josephholsten.com/descriptor.xrd'
    assert_equal expected, XRD::ResourceDiscovery.get_describedby_link(uri)
  end
end