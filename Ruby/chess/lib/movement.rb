require_relative 'king'
require_relative 'queen'
require_relative 'Pawn'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'

module Movement

	def up(x, y)
		(x, y+1)
	end

	def down(x, y)
		(x, y-1)
	end

	def right(x, y)
		(x+1, y)
	end

	def left(x, y)
		(x-1, y)
	end

	def up_right(x, y)
		(x+1, y+1)
	end

	def down_right(x, y)
		(x+1, y-1)
	end

	def up_left(x, y)
		(x-1, y+1)
	end

	def down_left(x, y)
		(x-1, y-1)
	end

	def knight(x, y)
		[[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1], [x + 1, y + 2], [x - 1, y + 2], [x + 1, y - 2], [x - 1, y - 2]]
	end

end