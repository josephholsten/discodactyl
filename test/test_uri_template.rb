#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl/uri_template"

class TestURITemplate < Test::Unit::TestCase
  def test_render_encode_uri
    t = Discodactyl::URITemplate.new('http://example.org?q={uri}')
    assert_equal('http://example.org?q=http%3A%2F%2Fexample.com%2Fr%3Ff%3D1', t.to_uri('uri' => URI.parse('http://example.com/r?f=1')))
  end
  # from http://tools.ietf.org/html/draft-hammer-hostmeta-05#section-3.2.1
  def test_render_encode
    t = Discodactyl::URITemplate.new('http://example.org?q={uri}')
    assert_equal('http://example.org?q=http%3A%2F%2Fexample.com%2Fr%3Ff%3D1', t.to_uri('uri' => 'http://example.com/r?f=1'))
  end
  def test_render_single
    t = Discodactyl::URITemplate.new('http://host.example/{%id}')
    assert_equal('http://host.example/test', t.to_uri('id' => 'test'))
  end

  def test_render_many
    t = Discodactyl::URITemplate.new('http://host.example/{%id}/{%name}')
    assert_equal('http://host.example/test/bob', t.to_uri('id' => 'test', 'name' => 'bob'))
  end

  def test_equivalence
    pattern = 'http://host.example/{%id}'
    assert_equal(Discodactyl::URITemplate.new(pattern), Discodactyl::URITemplate.new(pattern))
  end
end
