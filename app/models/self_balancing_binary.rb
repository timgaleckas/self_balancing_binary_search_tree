require 'active_support/core_ext/module'

module SelfBalancingBinary

  class Tree
    attr_accessor :root
    def root
      @root ||= Node.new
    end

    include Enumerable
    delegate :each, :find, :to => :root

    def <<( value )
      Array(value).each do |v|
        self.root << v
        self.root = SelfBalancingBinary.balance(self.root)
      end
      self
    end

  end

  class Node
    include Enumerable
    attr_accessor :left_child, :right_child, :hash_key, :bucket

    def <<( value_or_values )
      new_values = Array( value_or_values )
      while new_value = new_values.pop
        new_hash = new_value.hash
        case
        when self.hash_key.nil?
          add_to_bucket( new_value )
        when new_hash < self.hash_key
          self.left_child ||= Node.new
          self.left_child << new_value
        when new_hash > self.hash_key
          self.right_child ||= Node.new
          self.right_child << new_value
        else
          add_to_bucket( new_value )
        end
      end
      self
    end

    def each( &block )
      self.left_child && self.left_child.each( &block )
      self.hash_key.nil? || self.bucket.each( &block )
      self.right_child && self.right_child.each( &block )
    end

    def find( value_to_find )
      hash_to_find = value_to_find.hash
      case
      when self.hash_key.nil?
        nil
      when hash_to_find == self.hash_key
        self.bucket.find{|v| v == value_to_find }
      when hash_to_find < self.hash_key
        self.left_child && self.left_child.find( value_to_find )
      when hash_to_find > self.hash_key
        self.right_child && self.right_child.find( value_to_find )
      end
    end

    def depth
      [left_depth,right_depth].max + 1
    end

    def left_depth
        self.left_child && self.left_child.depth || 0
    end

    def right_depth
        self.right_child && self.right_child.depth || 0
    end

    def left_heavy?
      ( left_depth - right_depth ) > 1
    end

    def right_heavy?
      ( right_depth - left_depth ) > 1
    end

    def to_s( depth = 0 )
      ( self.left_child  ? self.left_child.to_s( depth + 1 ) : ''  ) +
      ((self.bucket      ? (('  ' * depth) + self.bucket.join(', ' ) + "\n") : '')) +
      ( self.right_child ? self.right_child.to_s( depth + 1 ) : '' )
    end

  protected
    def add_to_bucket( value )
      self.hash_key ||= value.hash
      self.bucket ||= []
      self.bucket << value
    end
  end
  protected
  class << self
    def rotate_right( node )
      pivot = node.left_child
      node.left_child = pivot.right_child
      pivot.right_child = node
      pivot
    end
    def rotate_left( node )
      pivot = node.right_child
      node.right_child = pivot.left_child
      pivot.left_child = node
      pivot
    end
    def balance( node )
      return node if node.nil?
      node.left_child = balance( node.left_child )
      node.right_child = balance( node.right_child )
      case
      when node.left_heavy?
        rotate_right( node )
      when node.right_heavy?
        rotate_left( node )
      else
        node
      end
    end
  end
end
