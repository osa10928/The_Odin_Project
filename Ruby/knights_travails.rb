def knight_moves (initial, destination)
  final_node = nil
  root = Node.new(initial, nil)
  queue = [root]
  queue.each do |node|
    if node.value == destination
      final_node = node
      break
    end
    a = create_children(node)
    queue << a
    queue.flatten!
  end
  display_path(final_node)
end
 
class Node
  attr_accessor :value, :parent
  def initialize (value, parent)
    @value = value
    @parent = parent
  end
end
 
def create_children(node)
  moves = []
  possible_moves_from(node).each do |possible_move|
    moves << Node.new(possible_move, node) if legal_move(possible_move) == true
  end
  return moves
end
 
def possible_moves_from(node)
  x, y = node.value
  [[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1], [x + 1, y + 2], [x - 1, y + 2], [x + 1, y - 2], [x - 1, y - 2]]
end
 
def legal_move(possible_move)
  x, y = possible_move
  return true if (1..8).include?(x) && (1..8).include?(y)
end
 
def display_path(final, path = [], value = final.parent)
  path << final.value
  return path.reverse if final.parent == nil
  final = final.parent
  display_path(final, path, value = final.parent)
end
 
knight_moves([1,1], [8,8])