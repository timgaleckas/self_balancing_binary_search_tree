class Node
  include Enumerable
  attr_accessor :left_child, :right_child, :hash, :bucket

  def <<( value_or_values )
    new_values = Array( value_or_values )
    while new_value = new_values.pop
      new_hash = new_value.hash
      case
      when self.hash.nil?
        add_to_bucket(new_value)
      when new_hash < self.hash
        self.left_child ||= Node.new
        self.left_child << new_value
      when new_hash > self.hash
        self.right_child ||= Node.new
        self.right_child << new_value
      else
        add_to_bucket(new_value)
      end
    end
 end

  def each( &block )
    self.left_child && self.left_child.each( &block )
    self.hash.nil? || self.bucket.each( &block )
    self.right_child && self.right_child.each( &block )
  end

  def find( value_to_find )
    hash_to_find = value_to_find.hash
    return nil if self.hash.nil?
    return self.bucket.find{|v| v == value_to_find} if hash_to_find == self.hash
    return self.left_child &&
           self.left_child.find( value_to_find ) if hash_to_find < self.hash
    return self.right_child &&
           self.right_child.find( value_to_find ) if hash_to_find > self.hash
  end

protected
  def add_to_bucket(value)
    self.hash ||= value.hash
    self.bucket ||= []
    self.bucket << value
 end


end
