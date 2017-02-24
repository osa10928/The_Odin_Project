class Mastermind

	def initialize
		@alphabet = ["A", "B", "C", "D", "E", "F"]
		@feedback = []
		run_game
	end
	
	def run_game
	  choose_code_breaker
		create_board
		@code = @maker.select_code
		game_loop
		winner
		play_again?
	end	
	
	def choose_code_breaker
	  puts "Would you like to make the code or break is (enter m or b)"
	  selection = gets.chomp.downcase
	  if selection == "m"
	    @maker = Human.new
	    @breaker = Cpu.new
	    puts selection
	  elsif selection == "b"
	    @breaker = Human.new
	    @maker = Cpu.new
	    @breaker.instruction
	  else
	    puts selection
	    puts "I didn't understand that."
	    choose_code_breaker
	  end
	end

	def run_game
	  choose_code_breaker
		create_board
		@code = @maker.select_code
		game_loop
		winner
		play_again?
	end

	def create_board
		@board = [["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"], ["_", "_", "_", "_"]]
	end
	
	def display
	  p ""
		p @board[0]
		p @board[1]
		p @board[2]
		p @board[3]
		p @board[4]
		p @board[5]
		p @board[6]
		p @board[7]
		p ""
		p @code
		p ""
	end
	
	def game_loop
		@guess_num = 0
		@correct_guess = false
		while @guess_num < 9
		  display
			@guess = @breaker.guess(@feedback, @guess)
			check
			if update == true
				@correct_guess = true
				break
			end
			@guess_num +=1
		end
	end

	def update
		if @corr_position == 4
			return true
		end
		@board[@guess_num] = @guess, @feedback
	end

	def check
	  @feedback = []
		@corr_position = 0
		@corr_letter = 0
		temp_code = []
		@code.each{|i| temp_code << i}
		@guess.each_with_index do |letter, i|
		  if letter == temp_code[i]
		    @corr_position += 1
		    @feedback << "!"
		    temp_code[i] = "X"
		  end
		end
		@guess.each_with_index do |letter, i|
		  if temp_code[i] == "X"
		    next
		  elsif temp_code.include?(letter)
		    @corr_letter += 1
		    @feedback << "?"
		    temp_code[temp_code.index(letter)] = "x"
		  else
		    @feedback << "0"
		  end
		end
		@feedback.shuffle
		return
	end

	def winner
		cpu_score = @guess_num
		if @correct_guess == true
			puts "You guessed correctly!!"
		end
		puts "cpu score: #{cpu_score}"
	end

	def play_again?
      puts "Would you like to play again? respond with a 'y' or an 'n')"
      answer = gets.chomp.downcase
      if answer == "y"
        Mastermind.new
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

  class Human
    
    attr_accessor :code, :guess
    
    def initialize
      @guess = []
      @code = []
      @alphabet = ["A", "B", "C", "D", "E", "F"]
    end
    
	  def instruction
	    puts "The secret code is  letters a-f in a particular order"
	    puts "guess 4 letters a-f to break the code"
	    puts "the computer will give you feedback"
	    puts "! means there is a correct letter/correct position"
	    puts "? means correct letter/incorrect postion"
	    puts "0 means neither correct letter or position"
	  end

	  def guess(feedback = nil, guess = nil)
		  puts "Guess!"
		  puts "(Enter 4 letters a-f sequentially with no spaces\
			  or periods. Then press enter)"
      @guess = gets.chomp.split("").map(&:to_s).map(&:upcase)
      if @guess.length != 4 || @guess.all?{|i| @alphabet.include?(i)} == false
        puts "That is not a correct entry"
        puts "Try again please"
        guess
      end
      return @guess
    end
    
    def select_code
		  puts "Select a code"
		  puts " Enter 4 letters a-f without spaces or periods to make code"
		  @code = gets.chomp.split("").map(&:to_s).map(&:upcase)
		  if @code.length != 4 || @code.all?{|i| @alphabet.include?(i)} == false
		    puts "That is not a correct entry"
        puts "Try again please"
        select_code
	    end
	    @code
	  end

end

	class Cpu
	  
	  attr_accessor :code, :guess
	  
	  def initialize
      @guess = []
      @code = []
      @alphabet = ["A", "B", "C", "D", "E", "F"]
    end
	  
    def guess(feedback, guess)
      @guess = []
      if feedback == []
	        4.times{ @guess << (65 + rand(6)).chr}
	       @guess
	    else
	       feedback.each_with_index do |feed, i|
	         if feed == "!"
	           @guess << guess[i]
	         elsif feed == "?"
	           @guess << guess[rand(3)]
	         else
	           @guess << @alphabet[rand(5)]
	         end
	       end
	    end
	    @guess
	  end

	  def select_code
		  @code = [@alphabet[rand(5)], @alphabet[rand(5)],\
		  @alphabet[rand(5)], @alphabet[rand(5)]]
		  @code
	  end
	end





play = Mastermind.new