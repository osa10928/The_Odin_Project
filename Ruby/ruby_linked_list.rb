class LinkedList
	def initialize
		@head = nil
		@tail = nil
		@number_of_nodes = 0
	end


	def append(value)
		@node = Node.new(value)
		@number_of_nodes += 1
		if @number_of_nodes == 1
		  @head = @node
		  @node.next_node = @tail
		else
			@head.next_node = @node
			@tail = @node
		end 
	end


	def prepend(value)
	  @node = Node.new(value)
	  @number_of_nodes += 1
	  @node.next_node = @head
	  @head = @node
	end
	
	def size
	  @number_of_nodes
	end
	
	def head
	  @head.value
	end
	
	def tail
	  @tail.value
	end

	def at(n)
	  count = n
	  node = @head
	  if count >= @number_of_nodes 
	    return nil
	  else 
	    while count > 0 
	      node = node.next_node
	      count -= 1
	    end
	  end
	  return node.value
	end

	def find_node(n)
	  count = n
	  node = @head
	  while count > 0 
	    node = node.next_node
	    count -= 1
	  end
	  return node
	end
	
	def find(node_index)
	  node = @head
	  count = 0
	  while node.value != node_index && count < @number_of_nodes - 1
	    node = node.next_node
	    count += 1 
	  end
	  node.value == node_index ? count : nil
	end
	
	def pop
	  new_tail = find_node(@number_of_nodes - 2)
	  popped = @tail
	  @tail = new_tail
	  return popped
	end
	
	def contains?(value)
	  (0...@number_of_nodes).each do |i|
	    if find_node(i).value == value
	      return true
	    end
	  end
	  return false
	end
	
	def to_s
	  string = []
	  (0...@number_of_nodes).each do |i|
	    string << find_node(i).value
	  end
	  string << nil
	  string.join(" -> ")
	end
	

end



class Node
	attr_accessor :value, :next_node
	def initialize (value = nil, next_node = nil)
		@value = value
		@next_node = next_node
	end

end


list = LinkedList.new
list.append(23)
list.append(45)
list.head
list.prepend(78)
list.head
list.size
list.at(2)
list.prepend(3)
list.tail
list.pop
list.tail
list.contains?(8)
list.find(5)
list.to_s