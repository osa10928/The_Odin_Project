#The board is actually made up of objects called squares
#The communicate betweent the board and the pieces
class Square

  attr_accessor :value, :piece

  def initialize (value, piece = nil)
    @value = value
    @piece = piece
  end

end