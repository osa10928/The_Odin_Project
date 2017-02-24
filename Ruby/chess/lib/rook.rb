require_relative 'pieces'

#Rook contains a castling variable which acts as a switch.
#It allows the board to know whether or not castling is possible 
class Rook < Pieces
	attr_accessor :color, :icon, :castling 

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2656"
		else
			@icon = "\u265C"
		end
	end
	@castling = true

end