#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl/link_header"

class TestLinkHeader < Test::Unit::TestCase
  def test_parse_rel_and_title
    link = '<http://example.com/TheBook/chapter2>; rel="previous"; title="previous chapter"'
    expected = {:href => 'http://example.com/TheBook/chapter2', :rel => ['previous'], :title => 'previous chapter'}
    assert_equal expected, Discodactyl::LinkHeader.parse(link)
  end
  
  def test_parse_seperated_rels
    link = '<http://example.org/>; rel=index; rel="start http://example.net/relation/other"'
    expected = {:href => 'http://example.org/', :rel => ['index', 'start', 'http://example.net/relation/other']}
    assert_equal expected, Discodactyl::LinkHeader.parse(link)
  end
  
  def test_parse_simple_link
    link = '</bar>; rel="http://example.com/profile1/foo"'
    expected = {:href => '/bar', :rel => ['http://example.com/profile1/foo']}
    assert_equal expected, Discodactyl::LinkHeader.parse(link)
  end
  
  def test_parse_xrd_link
    link = '<http://josephholsten.com/descriptor.xrd>; rel="describedby"; type="application/xrd+xml"'
    expected = {:href => 'http://josephholsten.com/descriptor.xrd', :rel => ['describedby'], :type => 'application/xrd+xml' }
    assert_equal expected, Discodactyl::LinkHeader.parse(link)
  end
end
