require_relative 'pieces'

#King contains a castling variable which acts as a switch.
#It allows the board to know whether or not castling is possible
class King < Pieces
	attr_accessor :color, :icon, :castling

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2654"
		else
			@icon = "\u265A"
		end
		@castling = true
	end

end