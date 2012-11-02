#!/usr/bin/env ruby -w
libdir = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "test/unit"

class TestKnownAccounts < Test::Unit::TestCase

  def test_dclinton
    expected =<<EOF
OpenID Provider: http://www.google.com/profiles/dclinton
Profile: http://www.google.com/profiles/dclinton
Profile data: http://www-opensocial.googleusercontent.com/api/people/117377434815709898403/
Contacts: http://www-opensocial.googleusercontent.com/api/people/
describedby: http://www.google.com/profiles/dclinton
EOF
    assert_equal expected, `bin/webfinger dclinton@gmail.com`
  end

  def test_romeda
    expected =<<EOF
OpenID Provider: http://www.google.com/profiles/romeda
Profile: http://www.google.com/profiles/romeda
Profile data: http://www-opensocial.googleusercontent.com/api/people/113651174506128852447/
Contacts: http://www-opensocial.googleusercontent.com/api/people/
describedby: http://www.google.com/profiles/romeda
EOF
    assert_equal expected, `bin/webfinger romeda@gmail.com`
  end

  def test_bradfitz
    expected =<<EOF
OpenID Provider: http://www.google.com/profiles/bradfitz
Profile: http://www.google.com/profiles/bradfitz
Profile data: http://www-opensocial.googleusercontent.com/api/people/115863474911002159675/
Contacts: http://www-opensocial.googleusercontent.com/api/people/
describedby: http://www.google.com/profiles/bradfitz
EOF
    assert_equal expected, `bin/webfinger bradfitz@gmail.com`
  end

  def test_willmeyer
    expected =<<EOF
describedby: http://www.google.com/profiles/willmeyer
EOF
    assert_equal expected, `bin/webfinger will@willmeyer.com`
  end

  def test_josephholsten
    expected =<<EOF
Name: Joseph Anthony Pasquale Holsten
Address: 5813 East 64th Place Tulsa Oklahoma 74136-2132 USA
OpenID Provider: https://www.myopenid.com/server
Profile: http://josephholsten.com
describedby: http://josephholsten.com
EOF
    assert_equal expected, `bin/webfinger joseph@josephholsten.com`
  end

  # Yahoo webfinger causes my ruby to segfault!
  # def test_gffletch
  #   expected =<<EOF
  #   assert_equal expected, `bin/webfinger dclinton@yahoo.com`
  #   assert_equal expected, `bin/webfinger beestage@yahoo.com`
  # end

  # AOL webfinger now dies at http://www.aol.com/.well-known/host-meta with 503
  # RIP
  # def test_gffletch
  #   expected =<<EOF
  #   assert_equal expected, `bin/webfinger gffletch@aol.com`
  # end
end
