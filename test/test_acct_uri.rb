#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"
require "discodactyl"

class TestURIAcct < Test::Unit::TestCase
  def test_parse_without_scheme
    a = URI::ACCT.parse('user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_parse_with_scheme
    a = URI::ACCT.parse('acct:user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_parse_uri_by_scheme
    a = URI.parse('acct:user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_build_from_hash
    a = URI::ACCT.build(:local_part => 'user',
      :host => 'host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_build_from_opaque
    a = URI::ACCT.build(:opaque => 'user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_build_from_array
    a = URI::ACCT.build(['user','host.example'])
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end


  def test_to_s
    a = URI::ACCT.build(:local_part => 'user',
      :host => 'host.example')
    assert_equal('acct:user@host.example', a.to_s)
  end
  def test_id
    a = URI::ACCT.build(:local_part => 'user',
      :host => 'host.example')
    assert_equal('user@host.example', a.id)
  end
end
