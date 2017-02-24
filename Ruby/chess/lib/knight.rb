require_relative 'pieces'

class Knight < Pieces
	attr_accessor :color, :icon

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2658"
		else
			@icon = "\u265E"
		end
	end

	def possible_moves(x, y)
		[[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1], [x + 1, y + 2], [x - 1, y + 2], [x + 1, y - 2], [x - 1, y - 2]]
	end


end