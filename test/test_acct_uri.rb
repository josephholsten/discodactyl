require "test/unit"
require "xrd"

class TestAcctURI < Test::Unit::TestCase
  def test_parse_simple
    a = AcctURI.parse('user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_parse_scheme
    a = AcctURI.parse('acct:user@host.example')
    assert_equal('user', a.local_part)
    assert_equal('host.example', a.host)
  end

  def test_to_s
    a = AcctURI.new
    a.local_part = 'user'
    a.host = 'host.example'
    assert_equal('user@host.example', a.to_s)
  end
end