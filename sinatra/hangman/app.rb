require_relative 'hangman.rb'
require 'sinatra'

configure do
	enable :sessions
end

get '/' do
	@play = false
	if session["game"]
		@word = session["game"].word
		win_lose
		@win_lose = true
		session["game"].win_lose == "won" ? \
		@output = "/images/hangman8.jpg" : @output = "/images/hangman7.jpg"
	else
		@win_lose = false 
		@output = "/images/hangman7.jpg"
	end
	erb:hang_man
end

get '/hangman/start' do
	session["game"] = Hangman.new
	state_of_game
	@output = get_output
	erb:hang_man
end

post '/hangman/play' do
	guess = params['guess']
	route(session["game"].validate(params['guess']), guess)
	@output = get_output
	if session["game"].win_lose
		win_lose
		redirect to('/')
	end
		erb:hang_man
end



helpers do
	def win_lose
		@message = "You Won!!" if session["game"].win_lose == "won"
		@message = "You Lost!!" if session["game"].win_lose == "lost"
	end

	def route(validation, guess)
		case validation
		when true
			session["game"].update(guess)
			state_of_game
		when false
			state_of_game
			@message = "That is not a valid entry"
		when nil
			state_of_game
			@message = "You've already guessed that"
		end
	end


	def state_of_game
		@message = nil
		@play = true
		@word = session["game"].word
		@word_hidden = session["game"].word_hidden.join(" ").gsub('"', '')
		@turns_left = session["game"].number_of_turns_left
		@abc = session["game"].abc_hidden.join(" ").gsub('"', '')
		@guess = session["game"].guess
	end

	def get_output
		return "/images/hangman7.jpg" if @turns_left == 0
		return "/images/hangman6.jpg" if @turns_left == 1
		return "/images/hangman5.jpg" if @turns_left == 2
		return "/images/hangman4.jpg" if @turns_left == 3
		return "/images/hangman3.jpg" if @turns_left == 4
		return "/images/hangman2.jpg" if @turns_left == 5
		return "/images/hangman1.jpg" if @turns_left == 6
		return "/images/hangman0.jpg" if @turns_left == 7
	end

end