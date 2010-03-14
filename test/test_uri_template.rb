#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl"

class TestURITemplate < Test::Unit::TestCase
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
