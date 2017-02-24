require_relative 'square.rb'
require_relative 'pieces'
require_relative 'king'
require_relative 'queen'
require_relative 'Pawn'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'

#Board acts as central information hub.
#In the end it decides what is possible and
#Ensures all rules are followed.
#Communicates with the game being run and the pieces
class Board
	attr_accessor :board

	def initialize
		create_board
		set_pieces
	end

	#Displays board
	def display(name, check)
		puts "Its #{name}'s turn to move"
		puts "You're in CHECK!!" if check == true
		print "  "
		("a".."h").each{|letter| print letter.center(4)}
		print "\n"
		(0..7).each do |y|
			print y+1
			(0..7).each do |x|
				piece = @board[x][y].piece
				icon = @board[x][y].piece.icon if piece.nil? == false
				print "|‾#{piece.nil? ? '‾' : icon}‾"
			end
			print "|\n"
		end
		8.times{print "‾‾‾‾".center(4)}
	end

	#Creates board from a hash
	def create_board
		@board = Hash.new
		(0..7).each do |x|
			@board[x] = []
			(0..7).each do |y|
				@board[x][y] = Square.new([x, y])
			end
		end
	end

	#Sets pieces
	#(As a black man I chose to have the black pieces in first person)
	def set_pieces
		(0..7).each do |row|
			case row
			when 0
				place_special_pieces(row, :white)
			when 1
				place_pawns(row, :white)
			when 6
				place_pawns(row, :black)
			when 7
				place_special_pieces(row, :black)
			end
		end
	end

	#Creates special pieces on the board
	def place_special_pieces(row, color)
		@board[0][row].piece = Rook.new(color)
		@board[1][row].piece = Knight.new(color)
		@board[2][row].piece = Bishop.new(color)
		@board[3][row].piece = King.new(color)
		@board[4][row].piece = Queen.new(color)
		@board[5][row].piece = Bishop.new(color)
		@board[6][row].piece = Knight.new(color)
		@board[7][row].piece = Rook.new(color)
	end

	#Creates the pawns on the board
	def place_pawns(row, color)
		(0..7).each do |square|
			@board[square][row].piece = Pawn.new(color)
		end
	end

	#Determines if the ending destination is viable
	#Checks whether the destination is on the board, if that piece can move in that manner and if that move would cause check for that player
	def viable_finish(color, x, y, start, check)
		return false if (0..7).include?(x) == false
		return false if (0..7).include?(y) == false
		if piece_possible_moves(color, x, y, start, check).include?([x, y]) != true && piece_possible_moves(color, x, y, start, check).include?([[x, y]]) != true
			return false
		end
		can_move_piece(start, x, y, color, check) == true ? true : (print "This would cause CHECK! "; return false)
	end

	#Determines if the player selected his piece
	def viable_entry(color, x, y)
		return false if (0..7).include?(x) == false
		return false if (0..7).include?(y) == false
		return false if @board[x][y].piece == nil
		return false if @board[x][y].piece.color != color
		return true
	end

	#Mocks a move and determines if that move would cause a check
	def can_move_piece(start, x, y, color, check)
		a, b = start
		if @board[x][y].piece != nil
			orgin = @board[x][y].piece
		else 
			orgin = nil
		end
		@board[x][y].piece = @board[a][b].piece
		@board[a][b].piece = nil
		if cause_check(color, check) == true
			@board[a][b].piece = @board[x][y].piece
			@board[x][y].piece = orgin
			return false
		else
			@board[a][b].piece = @board[x][y].piece
			@board[x][y].piece = orgin
			return true
		end
	end

	#Conducts all moves (removes pieces if a piece is captured)
	#Castles, en passants' and removes ability for an en passant
	def move(start, finish)
		a, b = start
		x, y = finish
		if @board[a][b].piece.class.name == "Pawn"
			@board[a][b].piece.double = "false"
			if y - b == 2 || y - b == -2
				@board[a][b].piece.en_passant = true
			end
		end
		if @board[a][b].piece.class.name == "King" || @board[a][b].piece.class.name == "Rook"
			@board[a][b].piece.castling = false
		end
		if @board[a][b].piece.class.name == "King" && (x - a >= 2 || x - a <= 2)
			if (x - a >= 2)
				castle_right(a, b, x, y)
			else
				castle_left(a, b, x, y)
			end
			return
		end
		@board[x][y].piece = @board[a][b].piece
		@board[a][b].piece = nil
		remove_en_passant(x, y)
		if @board[x][y].piece.class.name == "Pawn"
			check_promotion(x, y)
		end
	end	

	#Checks the moves of one team and determines if they can move to the spot where the king is:
	#Determines if there is a check
    def cause_check(color, check)
    	cause_check = false
    	 opposite_team_spaces = (color == :white ? team_pieces(:black) : team_pieces(:white))
    	 same_team_king = (color == :white ? king(:white) : king(:black))
    	 opposite_team_spaces.each do |space|
    	 	moves = piece_possible_moves(space.piece.color, x = nil, y = nil, space.value, check)
    	 	if moves.include?(same_team_king.value)
    	 		cause_check = true
    	 		break
    	 	end
    	 end
    	 return cause_check
    end

    #Determines if a team has any possible moves
    #(Might not have moves due to check or stalemate)
    def any_possible_moves?(color, check)
    	same_team_spaces = (color == :white ? team_pieces(:white) : team_pieces(:black))
    	same_team_spaces.each do |space|
    		moves = piece_possible_moves(space.piece.color, x = nil, y = nil, space.value, check)
    		next if moves.nil?
    		moves.compact!
    		moves.map! do |move|
    			next if move.all?{|x| x.nil?}
    			x, y = move
    			if can_move_piece(space.value, x, y, space.piece.color, check)
    				return true
    			end
    		end
    	end
    	return false
    end

 #Collects all the pieces locations of one team
 def team_pieces(color)
    	team_spaces = []
    	(0..7).each do |x|
    		(0..7).each do |y|
    			team_spaces << @board[x][y] if @board[x][y].piece != nil && @board[x][y].piece.color == color
    		end
    	end
    	team_spaces.flatten
    end

    #Collects the king's location of one team
    def king(color)
    	king = []
    	(0..7).each do |x|
    		(0..7).each do |y|
    			if @board[x][y].piece != nil && @board[x][y].piece.class.name == "King" && @board[x][y].piece.color == color
    				king = @board[x][y]
    				break
    			end
    		end
    	end
    	king
    end

    #Flips a switch which disallows en_passant
    def turn_off_en_passant(color)
    	pawns = collect_pawns(color)
		pawns.each{|pawn| pawn.piece.en_passant = false}
	end

	#Removes a piece which has been captured through en_passant
	def remove_en_passant(x, y)
		opposite_team_color = (@board[x][y].piece.color == :white ? :black : :white)
		pawns = collect_pawns(opposite_team_color)
		pawns.each do |pawn|
			if @board[x][y].piece.color == :white
				pawn.piece = nil if pawn.piece.en_passant == true && @board[x][y - 1] == pawn
			else
				pawn.piece = nil if pawn.piece.en_passant == true && @board[x][y + 1] == pawn
			end
		end
	end

	#determines if a spot is off the board
    def off_board(x, y)
    	if (x < 0 || x > 7 || y < 0 || y > 7)
    		return true
    	end
    	return false
    end

    #Determines which piece is being asked to move
    def piece_possible_moves(color, x, y, start, check)
		a, b = start
		case @board[a][b].piece.class.name
		when "King"
			possible_moves = moves_king(color, a, b, check)
		when "Queen"
			possible_moves = moves_queen(color, a, b)
		when "Bishop"
			possible_moves = moves_bishop(color, a, b)
		when "Knight"
			possible_moves = moves_knight(color, a, b)
		when "Rook"
			possible_moves = moves_rook(color, a, b)
		when "Pawn"
			possible_moves = moves_pawn(color, a, b)
		end
		possible_moves
	end

	#Collects all the pawns of one team
	def collect_pawns(color)
		pawns = []
		(0..7).each do |x|
			(0..7).each do |y|
				pawns << @board[x][y] if @board[x][y].piece != nil && @board[x][y].piece.class.name == "Pawn" && @board[x][y].piece.color == color
			end
		end
		return pawns
	end

		#Determines the moves a king can make at any given time
    	def moves_king(color, a, b, check)
		_moves = []
		(_moves << up(a, b) << down(a, b) << left(a, b) << right(a, b) << up_right(a, b) << up_left(a, b) << down_right(a, b) << down_left(a, b))
		_moves.map! do |spot|
			x, y = spot
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			spot if @board[x][y].piece == nil || @board[x][y].piece.color != color
		end
		_moves << ([a + 2, b] if castling_right(a, b, check) == true) << ([a - 2, b] if castling_left(a, b, check) == true)
		_moves.compact
	end

	#Determines the moves a queen can make at any given time
	def moves_queen(color, a, b)
		_moves = []
		(continue_left(color, a, b)).each{|move| _moves << move}
		(continue_right(color, a, b)).each{|move| _moves << move}
		(continue_up(color, a, b)).each{|move| _moves << move}
		(continue_down(color, a, b)).each{|move| _moves << move}
		(continue_up_left(color, a, b)).each{|move| _moves << move}
		(continue_up_right(color, a, b)).each{|move| _moves << move}
		(continue_down_left(color, a, b)).each{|move| _moves << move}
		(continue_down_right(color, a, b)).each{|move| _moves << move}
		_moves.compact
	end

	#Determines the moves a bishop can make at any given time
	def moves_bishop(color, a, b)
		_moves = []
		(continue_up_right(color, a, b)).each{|move| _moves << move}
		(continue_up_left(color, a, b)).each{|move| _moves << move}
		(continue_down_right(color, a, b)).each{|move| _moves << move} 
		(continue_down_left(color, a, b)).each{|move| _moves << move}
		_moves.compact
    end

    #Determines the moves a knight can make at any given time
    def moves_knight(color, a, b)
    	_moves = knight(a, b)
    	_moves.map! do |spot|
			x, y = spot
			next if (x < 0 || x > 7 || y < 0 || y > 7) 
			spot if (@board[x][y].piece == nil || @board[x][y].piece.color != color)
		end
		_moves.compact
    end

    #Determines the moves a rook can make at any given time
    def moves_rook(color, a, b)
    	_moves = []
    	(continue_up(color, a, b)).each{|move| _moves << move} 
    	(continue_down(color, a, b)).each{|move| _moves << move}
    	(continue_right(color, a, b)).each{|move| _moves << move}
    	(continue_left(color, a, b)).each{|move| _moves << move}
    	_moves.compact
    end

    #Determines the moves a pawn can make at any given time
    def moves_pawn(color, a, b)
    	_moves = []
    	if color == :white
    		if @board[a][b].piece.double == "true"
    			_moves << [a, b + 2] if @board[a][b + 2].piece == nil  		
    		end

    		x, y = up(a, b)
    		if off_board(x, y) == false
    			_moves << up(a, b) if @board[x][y].piece == nil
    		end

    		x, y = up_left(a, b)
    		if off_board(x, y) == false
    			_moves << up_left(a, b) if (@board[x][y].piece != nil && @board[x][y].piece.color != color) || en_passant_left(a, b)
    		end
    		
    		x, y = up_right(a, b)
    		if off_board(x, y) == false
    			_moves << up_right(a, b) if (@board[x][y].piece != nil && @board[x][y].piece.color != color) || en_passant_right(a, b)
    		end

    	else
    		if @board[a][b].piece.double == "true"
    			_moves << [a, b - 2] if @board[a][b - 2].piece == nil
    		end

    		x, y = down(a, b)
    		if off_board(x, y) == false
    			_moves << down(a, b) if @board[x][y].piece == nil
    		end

    		x, y = down_left(a, b)
    		if off_board(x, y) == false
    			_moves << down_left(a, b) if (@board[x][y].piece != nil || @board[a][b].piece.color != color) || en_passant_left(a, b)
    		end

    		x, y = down_right(a, b)
    		if off_board(x, y) == false
    			_moves << down_right(a, b) if (@board[x][y].piece != nil || @board[a][b].piece.color != color) || en_passant_right(a, b)
    		end
    	end
    	return _moves.compact
    end


    #Move vectors
	def up(x, y)
		[x, y + 1]
	end

	def down(x, y)
		[x, y - 1]
	end

	def right(x, y)
		[x + 1, y]
	end

	def left(x, y)
		[x - 1, y]
	end

	def up_right(x, y)
		[x + 1, y + 1]
	end

	def down_right(x, y)
		[x + 1, y - 1]
	end

	def up_left(x, y)
		[x - 1, y + 1]
	end

	def down_left(x, y)
		[x - 1, y - 1]
	end

	def knight(x, y)
		[[x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1], [x + 1, y + 2], [x - 1, y + 2], [x + 1, y - 2], [x - 1, y - 2]]
	end

	#Continous move vectors
	#(Determined by other pieces position on the board)
	def continue_up(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = up(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_down(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = down(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_right(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = right(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_left(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = left(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_up_right(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = up_right(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_up_left(color, x, y, continue = nil)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = up_left(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_down_right(color, x, y)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = down_right(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	def continue_down_left(color, x, y, possible_moves = nil)
		possible_moves = []
		continue = [[x, y]]
		continue.each do |spot|
			a, b = spot
			x, y = down_left(a, b)
			next if (x < 0 || x > 7 || y < 0 || y > 7)
			possible_moves << [x, y] if @board[x][y].piece == nil || @board[x][y].piece.color != color
			continue << [x, y] if @board[x][y].piece == nil
		end
		return possible_moves
	end

	#Determines of en_passant is possible on the left
	def en_passant_left(a, b)
		return true if @board[a - 1][b].piece != nil && @board[a - 1][b].piece.class.name == "Pawn" && @board[a - 1][b].piece.en_passant == true
	end

	#Determines of en_passant is possible on the right
	def en_passant_right(a, b)
		return true if @board[a + 1][b].piece != nil && @board[a + 1][b].piece.class.name == "Pawn" && @board[a + 1][b].piece.en_passant == true
	end

	#Determines if a promotion is possible
	def check_promotion(x, y)
		if @board[x][y].piece.color == :white && y == 7
			puts "Your pawn has achieved PROMOTION"
			puts "Enter the name of the piece you'd like to exchange you pawn for"
			puts "(watch your spelling!)"
			new_piece = gets.chomp.downcase
			case new_piece
			when "queen"
				@board[x][y].piece = Queen.new(:white)
			when "knight"
				@board[x][y].piece = Knight.new(:white)
			when "rook"
				@board[x][y].piece = Rook.new(:white)		
			when "bishop"
				@board[x][y].piece = Bishop.new(:white)
			else
				puts "I didn't understand that, try again"
				check_promotion
			end
		elsif @board[x][y].piece.color == :black && y == 0
			puts "Your pawn has achieved PROMOTION"
			puts "Enter the name of the piece you'd like to exchange you pawn for"
			puts "(watch your spelling!)"
			new_piece = gets.chomp.downcase
			case new_piece
			when "queen"
				@board[x][y].piece = Queen.new(:black)
			when "knight"
				@board[x][y].piece = Knight.new(:black)
			when "rook"
				@board[x][y].piece = Rook.new(:black)		
			when "bishop"
				@board[x][y].piece = Bishop.new(:black)
			else
				puts "I didn't understand that, try again"
				check_promotion
			end
		else
			return
		end
	end

	#Determines if castling is possible to the left
	def castling_left(a, b, check)
		team_color = (@board[a][b].piece.color == :white ? :white : :black)
		king = king(team_color)
		start = [a, b]
		return false if check
		return false if king.piece.castling == false
		return false if @board[a - 1][b].piece != nil || @board[a - 2][b].piece != nil
		return false if @board[a - 3][b].piece == nil || @board[a - 3][b].piece.color != team_color || @board[a - 3][b].piece.class.name != "Rook" || @board[a - 3][b].piece.castling == false
		return false if can_move_piece(start, a - 1, b, team_color, check) == false
		return true
	end

	#Determines if castling is possible in the right
	def castling_right(a, b, check)
		team_color = (@board[a][b].piece.color == :white ? :white : :black)
		king = king(team_color)
		start = [a, b]
		return false if check
		return false if king.piece.castling == false
		return false if @board[a + 1][b].piece != nil || @board[a + 2][b].piece != nil || @board[a + 3][b].piece != nil
		return false if @board[a + 4][b].piece == nil || @board[a + 4][b].piece.color != team_color || @board[a + 4][b].piece.class.name != "Rook" || @board[a + 4][b].piece.castling == false
		return false if can_move_piece(start, a + 1, b, team_color, check) == false
		return true
	end

	#Castles to the right
	def castle_right(a, b, x, y)
		@board[x][y].piece = @board[a][b].piece
		@board[a][b].piece = nil
		@board[x - 1][y].piece = @board[x + 2][y].piece
		@board[x + 2][y].piece = nil
	end

	#Castles to the left
	def castle_left(a, b, x, y)
		@board[x][y].piece = @board[a][b].piece
		@board[a][b].piece = nil
		@board[x + 1][y].piece = @board[x - 1][y].piece
		@board[x - 1][y].piece = nil
	end


end

