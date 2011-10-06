require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "insert" do
    n = Node.new
    assert_equal [], n.to_a
    n << 5
    assert_equal [5], n.to_a
    n << 5
    assert_equal [5], n.to_a
    n << 4
    assert_equal [4,5], n.to_a
    n << [ 4,5 ]
    assert_equal [4,5], n.to_a
    n << [ 6,5,4,3,2,1 ]
    assert_equal [1,2,3,4,5,6], n.to_a
    assert_nil n.find(8)
    assert_equal 5, n.find(5)
    assert_equal 1, n.find(1)
    assert_equal 6, n.find(6)
  end
end
