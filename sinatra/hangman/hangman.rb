require 'json'
require 'rubygems'
class Hangman
	attr_accessor :word, :word_hidden, :number_of_turns_left, :abc, :abc_hidden, :guess

	def initialize
		@number_of_turns_left = 7
		pick_word
		@word_hidden = []
		@word.split("").each{|i| @word_hidden << "_"}
		@abc = ("a".."z").to_a
		@abc_hidden = []
		25.times{@abc_hidden << "_"}
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

	def validate(guess)
		if guess.length > 1 || @abc.include?(guess) == false
			return false
		elsif @abc_hidden.include?(guess) || @word_hidden.include?(guess)
			return nil
		else
			return true
		end
	end

	def update(guess)
		if @word.include?(guess)
			index = []
			@word.split("").each_with_index do |l, i| 
				index << i if l == guess
			end
			index.each do |index|
				@word_hidden.each_with_index do |l, i|
					@word_hidden[i] = guess if i == index
				end
			end
		else
			@abc_hidden[abc.index(guess)] = guess
			@number_of_turns_left -= 1
		end
	end

	def win_lose
		if @word_hidden.include?("_") == false
			return "won"
		elsif @number_of_turns_left == 0
			return "lost"
		else
			return false
		end
	end


end
