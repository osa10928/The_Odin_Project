require 'sinatra'

def caesar_cipher(string, int)
	
	if int.to_i.to_s != int || int.to_i < 0
		return "Error! be sure to enter a positive integer"
	end

	int = int.to_i

	a = string.chars.map!{|i| i.ord}
	
	a.map! do |i|
	  if i.between?(65, 90) || i.between?(97, 122)
	    i+=int
	    (i > 122 || i.between?(90, 97)) ? i-=26: i=i
	  else
	    i = i
	  end
	end

a.map!{|i| i.chr}.join
	
end

get '/' do 
	string = params['message']
	int = params['increment']
	string == nil ? code = nil : code = caesar_cipher(string, int)
	erb :index, :locals => {:code => code}
end


