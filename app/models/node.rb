class Node
  include Enumerable
  attr_accessor :left_child, :right_child, :value

  def <<( value_or_values )
    new_values = Array( value_or_values )
    while new_value = new_values.pop
      case
      when self.value.nil?
        self.value = new_value
      when new_value < self.value
        self.left_child ||= Node.new
        self.left_child << new_value
      when new_value > self.value
        self.right_child ||= Node.new
        self.right_child << new_value
      else
        #my value is equal to current value
      end
    end
  end

  def each( &block )
    self.left_child && self.left_child.each( &block )
    self.value.nil? || block.call(self.value)
    self.right_child && self.right_child.each( &block )
  end

  def find( value_to_find )
    return self.value if self.value.nil? || value_to_find == self.value
    return self.left_child &&
           self.left_child.find( value_to_find ) if value_to_find < self.value
    return self.right_child &&
           self.right_child.find( value_to_find ) if value_to_find > self.value
  end
end
