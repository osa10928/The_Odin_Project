require_relative 'pieces'

#Pawn contains double and en passant variables which acts as switches
#They allow the board to know whether or not moving double is possible
#or whether they are susceptible to an en passant capture
class Pawn < Pieces
	attr_accessor :color, :icon, :double, :en_passant

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2659"
		else
			@icon = "\u265F"
		end
		@double = "true"
		@en_passant = false
	end

end