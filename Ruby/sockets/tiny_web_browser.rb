require 'socket'
require 'json'

host = 'localhost'
port = 2000


puts "Please enter the type of request you would like to send: GET or POST."
choice = gets.chomp.upcase

if choice == "GET"
  request = "GET /index.html HTTP/1.0\r\n\r\n"  
elsif choice == "POST"
  puts "Please enter your name."
  name = gets.chomp
  puts "Please enter your email address."
  email = gets.chomp
  data_hash = {:viking => {:name => name, :email => email} }
  data = data_hash.to_json
  request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{data.size}\r\n\r\n#{data}\r\n\r\n"
else
  puts "We're not sure what you said. Defaulting to GET."
  request = "GET /index.html HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host, port)
socket.print(request)
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
print body