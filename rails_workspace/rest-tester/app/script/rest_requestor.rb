require 'rest-client'
url = gets.chomp
puts RestClient.get(url)