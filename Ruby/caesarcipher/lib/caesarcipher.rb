require 'sinatra'
require 'sinatra/reloader'

def caesar_cipher(string, int)
	if int < 0
		raise ArgumentError
	end

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

get "/cipher" do 
	"hello world"
end


