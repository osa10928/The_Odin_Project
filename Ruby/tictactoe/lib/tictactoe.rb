class Ticatactoe

    def initialize 
        @board = {}
    @game_count = 0
    create_players
        run_game 
    end

    def run_game
        create_board
        display
        play_game
        who_won
        play_again?
    end

    def play_game
        @move_count = 0
        while @move_count < 9
          whose_turn
          make_move
          break if three_in_a_row == true
          @move_count += 1
        end
    end

    def make_move
        puts "Select move from 1 - 9"
        move = gets.chomp
        if viable_move(move) == true
          if @players_turn == @player1
             @board[move.to_i] = "_X_"
          else
            @board[move.to_i] = "_O_"
          end
        elsif viable_move(move) == "repeat"
          puts "That position is already taken! Try again!"
          make_move
        else
          puts "Thats not a viable move! Try again"
          make_move
        end
        display
    end

    def viable_move (move)
        viable_move = false
        if move.to_s.length == 1 && (1..9).include?(move.to_i) == true
          if @board[move.to_i] == "_X_" || @board[move.to_i] == "_O_"
            viable_move = "repeat"
          else
            viable_move = true
          end
        end
        return viable_move
    end



    def whose_turn
        if @game_count == 0 || @game_count.even?
          if @move_count == 0 || @move_count.even?
            @players_turn = @player1
          else
            @players_turn = @player2
          end
        end
        if @game_count.odd?
          if @move_count == 0 || @move_count.even?
            @players_turn = @player2
          else
            @players_turn = @player1
          end
        end
        puts "Its #{@players_turn} turn to make a move!"
    end

    def create_players
        puts "Player1 enter name:"
        @player1 = gets.chomp
        puts "Player2 enter name:"
        @player2 = gets.chomp
    end

    def create_board
        @board = {
            1 => "_1_",
            2 => "_2_",
            3 => "_3_",
            4 => "_4_",
            5 => "_5_",
            6 => "_6_",
            7 => "_7_",
            8 => "_8_",
            9 => "_9_",
        }
    end

    def display
        puts ""
        puts "#{@board[1]} #{@board[2]} #{@board[3]}"
        puts "#{@board[4]} #{@board[5]} #{@board[6]}"
        puts "#{@board[7]} #{@board[8]} #{@board[9]}"
        puts ""
    end
    
    def three_in_a_row
      if (@board[1] == @board[2] && @board[1] == @board[3]) || \
         (@board[1] == @board[5] && @board[1] == @board[9]) || \
         (@board[1] == @board[4] && @board[1] == @board[7]) || \
         (@board[2] == @board[5] && @board[2] == @board[8]) || \
         (@board[3] == @board[5] && @board[3] == @board[7]) || \
         (@board[4] == @board[5] && @board[4] == @board[6]) || \
         (@board[7] == @board[8] && @board[7] == @board[9])
         
         three_in_a_row = true
      else
        three_in_a_row = false
      end
      return three_in_a_row
    end
    
    def who_won
      if @move_count < 9 
        puts "The winner is #{@players_turn}!!!"
      else
        puts "Cats Game!!"
      end
    end
    
    def play_again?
      puts "Would you like to play again? respond with a 'y' or an 'n')"
      answer = gets.chomp.downcase
      if answer == "y"
        @game_count += 1
        run_game
      elsif answer == "n"
        end_game
      else answer != "y" || answer != "n"
        puts "That is not an appropriate answer! Try again"
        play_again?
      end
    end
    
    def end_game
      puts "Thanks for playing!!"
    end

end

game = Ticatactoe.new