require 'test_helper'

class SelfBalancingBinaryTreeTest < ActiveSupport::TestCase

  #copied from http://rubydoc.info/gems/shoulda/2.11.3/Shoulda/Assertions#assert_same_elements-instance_method
  def assert_same_elements(a1, a2, msg = nil)
    [:select, :inject, :size].each do |m|
      [a1, a2].each {|a| assert_respond_to(a, m, "Are you sure that #{a.inspect} is an array?  It doesn't respond to #{m}.") }
    end

    assert a1h = a1.inject({}) { |h,e| h[e] = a1.select { |i| i == e }.size; h }
    assert a2h = a2.inject({}) { |h,e| h[e] = a2.select { |i| i == e }.size; h }

    assert_equal(a1h, a2h, msg)
  end

  test "insert" do
    n = SelfBalancingBinary::Tree.new
    assert_equal [], n.to_a
    n << 5
    assert_equal [5], n.to_a
    n << 5
    assert_equal [5,5], n.to_a
    n << 4
    assert_same_elements [4,5,5], n.to_a
    n << [ 4,5 ]
    assert_same_elements [4,4,5,5,5], n.to_a
    n = SelfBalancingBinary::Tree.new
    n << [ 6,5,4,3,2,1 ]
    assert_same_elements [1,2,3,4,5,6], n.to_a
    assert_nil n.find(8)
    assert_equal 5, n.find(5)
    assert_equal 1, n.find(1)
    assert_equal 6, n.find(6)
  end

  test "insert multiple types" do
    n = SelfBalancingBinary::Tree.new
    n << "hello"
    n << 5
  end

  test "insert a hash collision" do
    class HashCollidingString < String
      def hash
        1
      end
    end
    n = SelfBalancingBinary::Tree.new

    hello  = HashCollidingString.new('hello')
    hello2 = HashCollidingString.new('hello2')

    n << [ hello, hello2 ]
    assert_equal hello, n.find(hello)
    assert_equal hello2, n.find(hello2)
  end

  test 'self balance' do
    n = 100
    sample_size = 10
    1.upto(sample_size) do
      t = SelfBalancingBinary::Tree.new
      t << 1.upto(n).to_a.shuffle
      assert_operator t.root.depth, :<=, 2*(Math.log(n) / Math.log(2))
    end
    t = SelfBalancingBinary::Tree.new
    t << 1.upto(n).to_a
    assert_operator t.root.depth, :<=, 2*(Math.log(n) / Math.log(2))
    t = SelfBalancingBinary::Tree.new
    t << 1.upto(n).map{|i|n+1-i}
    assert_operator t.root.depth, :<=, 2*(Math.log(n) / Math.log(2))
  end
end
