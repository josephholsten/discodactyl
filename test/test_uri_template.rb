#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl"

class TestURITemplate < Test::Unit::TestCase
  def test_render_encode_uri
    t = URITemplate.new('http://example.org?q={uri}')
    assert_equal('http://example.org?q=http%3A%2F%2Fexample.com%2Fr%3Ff%3D1', t.to_uri('uri' => URI.parse('http://example.com/r?f=1')))
  end
  def test_render_encode
    t = URITemplate.new('http://example.org?q={uri}')
    assert_equal('http://example.org?q=http%3A%2F%2Fexample.com%2Fr%3Ff%3D1', t.to_uri('uri' => 'http://example.com/r?f=1'))
  end
  def test_render_single
    t = URITemplate.new('http://host.example/{%id}')
    assert_equal('http://host.example/test', t.to_uri('id' => 'test'))
  end

  def test_render_many
    t = URITemplate.new('http://host.example/{%id}/{%name}')
    assert_equal('http://host.example/test/bob', t.to_uri('id' => 'test', 'name' => 'bob'))
  end

  def test_equivalence
    pattern = 'http://host.example/{%id}'
    assert_equal(URITemplate.new(pattern), URITemplate.new(pattern))
  end
end
