require_relative 'pieces'

class Bishop < Pieces
	attr_accessor :color, :icon  

	def initialize(color = nil)
		@color = color
		if @color == :white
			@icon = "\u2657"
		else
			@icon = "\u265D"
		end
	end

end