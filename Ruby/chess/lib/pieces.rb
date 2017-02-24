#Pieces is the parent of all the individual pieces
#Allowed for ease of communication when referencing a nonspecific piece
class Pieces

	def initialize (color)
		@color = color
	end
end

require_relative 'king'
require_relative 'queen'
require_relative 'Pawn'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'