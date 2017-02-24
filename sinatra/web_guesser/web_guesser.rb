require 'sinatra'
require 'sinatra/reloader'

@@number = rand(100)
@@guesses = 5

def guess_game(guess)
	if @@guesses == 1 && guess != @@number
		message = "Your out of guesses!! The number was #{@@number}"
		reset
	elsif check_guess(guess) == "You got it right!"
		message = check_guess(guess) + "#{@@number}"
		reset
	else
		@@guesses -= 1
		message = check_guess(guess)
	end
	return message
end

def check_guess(guess)
	guess = guess.to_i
	if guess > @@number
		if guess > @@number + 5
			return "Way too high!"
		else
			return "Too High!"
		end
	elsif guess < @@number
		if guess < @@number - 5
			return "Way too low!"
		else
			return "Too Low!"
		end
	else
		return "You got it right!"
	end
end

def reset
	@@number = rand(100)
	@@guesses = 5
end




get '/guesser' do 
	guess = params['guess']
	guess == nil ? message = nil : message = guess_game(guess)
	erb :index, :locals => {:guesses => @@guesses, :guess => guess, :number => @@number, :message => message}
end