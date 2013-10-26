#
# macaddr.rb - A class to manipulate MAC addresses
#
# Copyright (c) 2013 Dustin Lundquist <dustin@null-ptr.net>
# All rights reserved.
#
# You can redistribute and/or modify it under the same terms as Ruby.
#
class MACAddr

  # Creates a new MACAddr object from a canonical string format.
  #
  # A MACAddr is stored as an array of bytes in transmission order.
  def initialize(addr = '00:00:00:00:00:00')
    cleaned = addr.gsub(/[^a-zA-Z0-9]/, '')
    bytes = cleaned.scan(/../)

    @addr = bytes.map{|i| i.hex}.freeze
  end

  def inspect
    return sprintf("#<%s: %s>", self.class.name, to_s)
  end

  def to_a
    return @addr
  end

  # Returns the Organisationally Unique Identifier (OUI).
  def oui
    return @addr[0..2].map{|i| "%02x" % i }.join(':')
  end

  # Returns the Network Interface Controller Specifier.
  def nic
    return @addr[3..5].map{|i| "%02x" % i }.join(':')
  end

  # Returns a Modified EUI-64 identifier suitable for building an IPv6 address
  def eui64
    eui64_addr = [@addr[0] | 0x02] + @addr[1..2] + [0xff, 0xfe] + @addr[3..5]
    return eui64_addr.each_slice(2).map{|i| "%x%x" % i }.join(':')
  end

  def group?
    return (@addr[0] & 0x01) == 0x01
  end

  def individual?
    return !group?
  end

  def universally_administered?
    return (@addr[0] & 0x02) == 0x02
  end

  def locally_administered?
    return !universally_administered?
  end

  # Returns the integer representation of the macaddr.
  def to_i
    return @addr.inject(0) do |acc, i|
        acc << 8 | i
    end
  end

  # Returns the canonical string representation of the macaddr.
  def to_s
    return @addr.map{|i| "%02x" % i }.join(':')
  end
end

__END__

require 'test/unit'

class TC_MACAddr < Test::Unit::TestCase
  def test_s_new
    a = MACAddr.new
    assert_equal('00:00:00:00:00:00', a.to_s)
    assert_equal(0, a.to_i)

    a = MACAddr.new('00:00:00:00:00:01')
    assert_equal('00:00:00:00:00:01', a.to_s)
    assert_equal(1, a.to_i)

    a = MACAddr.new("56:6f:99:d2:aa:f9")
    assert_equal("56:6f:99:d2:aa:f9", a.to_s)

    a = MACAddr.new("56-6F-99-D2-AA-F9")
    assert_equal("56:6f:99:d2:aa:f9", a.to_s)

    a = MACAddr.new("566f.99d2.aaf9")
    assert_equal("56:6f:99:d2:aa:f9", a.to_s)
  end

  def test_group
    a = MACAddr.new
    assert_equal(false, a.group?)
    assert_equal(true, a.individual?)

    a = MACAddr.new('33:33:00:00:00:01')
    assert_equal(true, a.group?)
    assert_equal(false, a.individual?)
  end

  def test_eui64
    a = MACAddr.new('3c:97:0e:7e:52:12')
    assert_equal('3e97:eff:fe7e:5212', a.eui64)
  end
end
