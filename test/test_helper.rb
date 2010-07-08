require "test/unit"
module Test::Unit::Assertions
  def assert_length(expected, enum, message = nil)
    message = build_message message, '<?> is not length <?>', enum, expected
    assert_equal expected, enum.length, message
  end

  def assert_include?(atom, enum, message = nil)
    message = build_message message, '<?> does not include <?>.', enum, atom
    assert enum.include?(atom), message
  end
end

class Test::Unit::TestCase
  require 'rr'
  include RR::Adapters::TestUnit
end
