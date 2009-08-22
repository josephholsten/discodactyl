require "test/unit"
require "xrd"

class TestLinkHeader < Test::Unit::TestCase
  def test_parse_rel_and_title
    link = 'Link: <http://example.com/TheBook/chapter2>; rel="previous"; title="previous chapter"'
    expected = {:href => 'http://example.com/TheBook/chapter2', :rel => ['previous'], :title => 'previous chapter'}
    assert_equal expected, XRD::ResourceDiscovery.parse_link_header(link)
  end
  
  def test_parse_seperated_rels
    link = 'Link: <http://example.org/>; rel=index; rel="start http://example.net/relation/other"'
    expected = {:href => 'http://example.org/', :rel => ['index', 'start', 'http://example.net/relation/other']}
    assert_equal expected, XRD::ResourceDiscovery.parse_link_header(link)
  end
  
  def test_parse_simple_link
    link = 'Link: </bar>; rel="http://example.com/profile1/foo"'
    expected = {:href => '/bar', :rel => ['http://example.com/profile1/foo']}
    assert_equal expected, XRD::ResourceDiscovery.parse_link_header(link)
  end
  
  def test_parse_xrd_link
    link = 'Link: <http://josephholsten.com/descriptor.xrd>; rel="describedby"; type="application/xrd+xml"'
    expected = {:href => 'http://josephholsten.com/descriptor.xrd', :rel => ['describedby'], :type => 'application/xrd+xml' }
    assert_equal expected, XRD::ResourceDiscovery.parse_link_header(link)
  end
end