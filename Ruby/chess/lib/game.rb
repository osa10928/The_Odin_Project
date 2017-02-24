require_relative 'board.rb'
require_relative 'chess.rb'
require 'yaml'
class Chess
	attr_accessor :board, :player1, :player2, :check

	def initialize
		@board = Board.new
		@player_turn = nil
		load_game?
		introduction
		run_game
	end

	def load_game?
		puts "Would you like to load a previously saved game"
		puts "(yes or no)"
		answer = gets.chomp.downcase
		if answer == "yes"
			load
		elsif answer == "no"
			return
		else
			puts "I did not understand that answer, try again"
			load_game?
		end
	end

	def introduction
		puts "Welcome to command line chess! The rules are the same"
		puts "As regular chess. En Passant, castling, and all that jazz!"
		puts "Making a move is easy"
		puts "First entering the coordinates of the piece you want to move"
		puts "next enter the coordinates of that pieces destination"
		puts "Example: enter a2. Then enter a3 to move the a2 pawn"
	end

	def run_game
		if @player_turn == nil
			puts "white team name:"
			a = gets.chomp
			puts "black team name:"
			b = gets.chomp
		end
		@player1 = Player.new(:white, a)
		@player2 = Player.new(:black, b)
		@player_turn == nil ? player_turn = @player1 : player_turn = @player_turn
		@check == nil ? check = false : check = @check
		while @board.any_possible_moves?(player_turn.color, check)
			
			@check = check
			@player_turn = player_turn

			choose_move(player_turn, check)
			
			check = @check
			player_turn = @player_turn
			
			if @viable_move == true
				player_turn = switch_player(player_turn)
				@board.turn_off_en_passant(player_turn.color)
			end
			@board.cause_check(player_turn.color, check) == true ? check = true : check = false
		end
		if check == true
			@board.display(player_turn, check)
			print "#{player_turn.name} can no longer make a move! CHECKMATE! \n"
			print "#{switch_player(player_turn).name} WINS!!!"
		else
			print "This contest ends in a stalemate."
		end
	end

	def choose_move(player, check)
		@viable_move = false
		finish = nil
		start = get_space(player, check, "start", nil)
		if start == "save"
			save_game
			start = nil
		end
		finish = get_space(player, check, "finish", start) unless start == nil
		if finish != nil
			@board.move(start, finish)
			@viable_move = true
		end
	end	

	def get_space(player, check, start_or_finish, start)
		@board.display(player.name, check)
		entry = gets.chomp.downcase
		if verify(entry) == "save"
			return "save"
		elsif verify(entry) == false
			return
		end
		x, y = entry.split("")
		x = x.ord - 97
		y = y.to_i - 1
		if start_or_finish == "start"
			if @board.viable_entry(player.color, x, y) == false
				puts "That is not a viable entry. Please try again"
				choose_move(player, check)
				return
			end
		else
			if @board.viable_finish(player.color, x, y, start, check) == false
				puts "That is not a viable entry. Please try again"
				choose_move(player, check)
				return
			end
		end
		return [x, y]
	end

	def verify(entry)
		return "save" if entry == "save"
		if entry.length != 2
			puts "wrong type of entry"
			return false
		end
		return true
	end
				

	def switch_player(player_turn)
		player_turn == @player1 ? @player2 : @player1
	end

	def save_game
		Dir.mkdir('saved_games') unless Dir.exist? 'saved_games'
		Dir.chdir("saved_games")
		data = save
		File.open("save.yaml", "w") do |file|
			saved_games = YAML::dump(data)
			file.write(saved_games)
		end
		puts "Games Saved!!"
		abort
	end

	def save
		[@board, @player1, @player2, @player_turn, @check]
	end

	def load
		Dir.mkdir('saved_games') unless Dir.exist? 'saved_games'
		Dir.chdir("saved_games")
		if File.exist?("save.yaml")
			data = YAML::load_file('save.yaml')
			@board = data[0]
			@player1 = data[1]
			@player2 = data[2]
			@player_turn = data[3]
			@check = data[4]
			Dir.chdir(File.expand_path("..", Dir.pwd))
		else
			puts "There are no saved games"
			@game = Game.new
		end
	end
end

class Player
	attr_accessor :color, :name

	def initialize (color, name)
		@name = name
		@color = color
	end
end


a = Chess.new

