require 'json'
require 'rubygems'
class Hangman
	attr_accessor :word, :word_hidden, :number_of_turns_left, :abc, :abc_hidden, :guess

	def initialize
		@word = nil
		@number_of_turns_left = 7
		@word_hidden = []
		pick_word
		create_board(@word)
		game_loop(@word)
	end

	def pick_word
		dictionary = File.open("dictionary.txt")
		dictionary.each_with_index do |line, number|
			@word = line.chomp.downcase if (rand < 1.0/(number))
		end
		if @word.length < 5 || @word.length > 12
			pick_word
		end
	end

	def create_board(word)
		word.split("").each{|i| @word_hidden << "_"}
		@abc = ("a".."z").to_a
		@abc_hidden = []
		25.times{@abc_hidden << "_"}
	end

	def game_loop(word)
		while @number_of_turns_left >=0
		  display
		  pick_letter
		  update(word, @abc)
		  win_lose
	    end
	end

	def display
		p "YOU HAVE ONLY #{@number_of_turns_left} MORE CHANCES!!"
		p "Guess this word!!"
		puts
		puts
		p @word_hidden
		puts
		puts
		p "Letters Guessed:"
		puts
		p @abc_hidden
		p "               To \'save\' to save game, \'load\' to load game and \'exit\' to quit"
	end

	def pick_letter
		puts "Pick a letter you think is in this word!"
		@guess = gets.chomp.downcase
		end_game if @guess == "exit"
		if @guess == "save"
			save 
		elsif @guess == "load"
			load
		elsif @guess.length > 1 || @abc.include?(@guess) == false
			puts "That is not a correct guess, try again"
			pick_letter
		elsif @abc_hidden.include?(@guess)
			puts "You've already guessed that silly. Try again"
			pick_letter
		end
	end

	def update(word, abc)
		if word.include?(@guess)
			index = []
			word.split("").each_with_index do |l, i| 
				index << i if l == @guess
			end
			index.each do |index|
				@word_hidden.map.each_with_index do |l, i|
					@word_hidden[i] = @guess if i == index
				end
			end
		else
			@abc_hidden[abc.index(@guess)] = @guess
			@number_of_turns_left -= 1
		end
	end

	def win_lose
		if @word_hidden.include?("_") == false
			puts "You got it!!! Nice!!"
			play_again?
		elsif @number_of_turns_left <= 0
			puts "You didn't get it :("
			puts "This was the word: #{@word}"
			play_again?
		else
			return
		end
	end

	def play_again?
      puts "Would you like to play again? respond with a 'y' or an 'n')"
      answer = gets.chomp.downcase
      if answer == "y"
        initialize
      elsif answer == "n"
        end_game
      else answer != "y" || answer != "n"
        puts "That is not an appropriate answer! Try again"
        play_again?
      end
  end

  def to_json
  	store = JSON.dump ({
  		:word => @word, :word_hidden => @word_hidden, :guess => @guess,\
  		:number_of_turns_left => @number_of_turns_left, :abc => @abc, :abc_hidden => @abc_hidden
  		})
  end

  def from_json(string)
  	data = JSON.parse(string)
  	@word = data["word"]
  	@word_hidden = data["word_hidden"]
  	@number_of_turns_left = data["number_of_turns_left"]
  	@abc = data["abc"]
  	@abc_hidden = data["abc_hidden"]
  	@guess = data["guess"]
  end

  def save
  	Dir.mkdir('saved_games') unless Dir.exist? 'saved_games'

  	puts "name your game (in all lowercase please)"
  	name_of_game = gets.chomp.downcase
  	Dir.chdir("saved_games")
  	save_file = File.open(name_of_game, 'w+')
  	json_string = to_json
  	save_file.write(json_string)
  	puts "Game is saved!"
  	Dir.chdir(File.expand_path("..", Dir.pwd))
  	play_again?
  end

  def load
  	if Dir.entries('saved_games').size > 2
  		puts "Type in the name of your saved game"
  		Dir.foreach('saved_games') {|file| puts file unless file == ".." || file == "."}
  		not_picked = true
  		name_of_file = nil

  		while not_picked
  			if name_of_file == "exit"
  				Dir.chdir(File.expand_path("..", Dir.pwd))
  				break
  			end
  			name_of_file = gets.chomp


  			Dir.foreach('saved_games') {|file| not_picked = false if name_of_file == file} 
  			puts "Please pick an appropriate file name or enter \'exit\' to exit" \
  			if not_picked == true
  		end
  		Dir.chdir('saved_games')
  		file = File.readlines(name_of_file)
  		from_json(file[0])
  		if @word != nil 
  			File.delete(name_of_file)
  		end
  		Dir.chdir(File.expand_path("..", Dir.pwd))
  		game_loop(@word)

  	else
  		puts "There are no saved games"
  		pick_letter
  	end
  end

    
  def end_game
    puts "Thanks for playing!!"
    exit
  end



end


game = Hangman.new