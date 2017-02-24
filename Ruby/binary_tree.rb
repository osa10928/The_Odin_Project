class Binary_Tree
	attr_reader :root

	def initialize (imput_array)
		@root = nil
		@node = nil
		@intermediate_node = nil
		if imput_array.instance_of?(Array) == false
			raise ArgumentError, 'Argument is not an Array'
			abort
		else
			imput_array.each{|node_value| create_tree(node_value)}
		end
	end

	def create_tree(node_value)
		if @root == nil
			create_root(node_value)
		else
		  @intermediate_node = @root
			attach_node(node_value)
		end
	end

	def create_root(node_value)
		@node = Node.new(node_value)
		@root = @node
	end

	def attach_node(node_value)
		if node_value <= @intermediate_node.value
			if @intermediate_node.left_child == nil
				@node = Node.new(node_value)
				@node.parent = @intermediate_node
				@intermediate_node.left_child = @node
			else
			  @intermediate_node = @intermediate_node.left_child
				attach_node(node_value)
			end
		else
			if @intermediate_node.right_child == nil
				@node = Node.new(node_value)
				@node.parent = @intermediate_node
				@intermediate_node.right_child = @node
			else
			  @intermediate_node = @intermediate_node.right_child
				attach_node(node_value)
			end
		end
	end

	def breadth_first_search(value)
		array_queue = [@root]
		array_queue.each do |node|
			return node if node.value == value
			array_queue << node.left_child if node.left_child
			array_queue << node.right_child if node.right_child
		end
	end

	def depth_first_search(value)
		array_stack = [@root]
		loop do
			break if array_stack.empty?
			node = array_stack.pop
			return node if node.value == value
			array_stack << node.left_child if node.left_child
			array_stack << node.right_child if node.right_child
		end
		return
	end



end

class Node
	attr_accessor :left_child, :right_child, :parent, :value

	def initialize (value)
		@value = value
		@left_child, @right_child, @parent = nil
	end
end

a = Binary_Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].shuffle)
a.root