require_relative 'pieces'

class Queen < Pieces
	attr_accessor :color, :icon

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2655"
		else
			@icon = "\u265B"
		end
	end

end