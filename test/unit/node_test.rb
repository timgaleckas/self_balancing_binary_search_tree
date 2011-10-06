require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  test "insert" do
    n = Node.new
    assert_equal [], n.to_a
    n << 5
    assert_equal [5], n.to_a
    n << 5
    assert_equal [5,5], n.to_a
    n << 4
    assert_equal [4,5,5], n.to_a
    n << [ 4,5 ]
    assert_equal [4,4,5,5,5], n.to_a
    n = Node.new
    n << [ 6,5,4,3,2,1 ]
    assert_equal [1,2,3,4,5,6], n.to_a
    assert_nil n.find(8)
    assert_equal 5, n.find(5)
    assert_equal 1, n.find(1)
    assert_equal 6, n.find(6)
  end

  test "insert multiple types" do
    n = Node.new
    n << "hello"
    n << 5
  end

  test "insert a hash collision" do
    class HashCollidingString < String
      def hash
        1
      end
    end
    n = Node.new

    hello  = HashCollidingString.new('hello')
    hello2 = HashCollidingString.new('hello2')

    n << [ hello, hello2 ]
    assert_equal hello, n.find(hello)
    assert_equal hello2, n.find(hello2)
  end
end
