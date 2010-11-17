#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl/host_meta_jrd"
require 'discodactyl/acct_uri'

class TestHostMetaJRD < Test::Unit::TestCase
  def test_get_uri_from_host
    uri = 'host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta.json'
    assert_equal expected, Discodactyl::HostMetaJRD.get_uri_from_uri(uri)
  end

  def test_get_uri_from_http
    uri = URI.parse 'http://host.example/some/path'
    expected = URI.parse 'http://host.example/.well-known/host-meta.json'
    assert_equal expected, Discodactyl::HostMetaJRD.get_uri_from_uri(uri)
  end

  def test_get_uri_from_acct
    uri = URI.parse 'acct:user@host.example'
    expected = URI.parse 'http://host.example/.well-known/host-meta.json'
    assert_equal expected, Discodactyl::HostMetaJRD.get_uri_from_uri(uri)
  end
  
  def test_from_uri
    uri = URI.parse 'acct:josephholsten@localhost'
    assert_equal({"links"=>{"lrdd"=>[{"href"=>"http://localhost/discovery.jrd"}]}}, Discodactyl::HostMetaJRD.from_uri(uri))
  end

  def test_parse
    json = <<JSON
{ "links": {
    "lrdd": [{
      "href":"http://host.example/discovery.jrd" }]}}
JSON
    assert_equal({"links"=>{"lrdd"=>[{"href"=>"http://host.example/discovery.jrd"}]}}, Discodactyl::HostMetaJRD.parse(json))
  end

  def test_links_by_rel
    jrd = Discodactyl::HostMetaJRD[{"links"=>{"lrdd"=>[{"href"=>"http://host.example/discovery.jrd"}]}}]
    expected = [Discodactyl::JRD::Link.parse({'href'=>'http://host.example/discovery.jrd', 'rel' => 'lrdd'})]
    assert_equal(expected, jrd.links_by_rel('lrdd'))
  end
  
  # links by rel when links is missing, when rel is missing
  def test_links_by_rel_when_missing
    jrd = Discodactyl::HostMetaJRD[{}]
    assert_equal([], jrd.links_by_rel('lrdd'))
  end

  def test_uris_by_rel
    jrd = Discodactyl::HostMetaJRD[{"links"=>{"lrdd"=>[{"href"=>"http://host.example/discovery.jrd"}]}}]
    assert_equal(['http://host.example/discovery.jrd'], jrd.uris_by_rel('lrdd'))
  end

  def test_uris_by_rel_with_template
    jrd = Discodactyl::HostMetaJRD[{"links"=>{"lrdd"=>[{"template"=>"http://host.example/{id}"}]}}]
    assert_equal(['http://host.example/foo'], jrd.uris_by_rel('lrdd', 'id' => 'foo'))
  end
end
