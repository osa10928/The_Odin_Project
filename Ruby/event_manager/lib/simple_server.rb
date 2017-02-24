require 'socket'
require 'json'

server = TCPServer.open(2000)

loop {

  client = server.accept
  request_message = ""
  while line = client.gets
  	request_message << line
  	break if request_message =~ /\r\n\r\n$/
  end

  request_method = request_message.split[0]
  request_file = request_message.split[1][1..-1]

  if File.exists?(request_file)

    file = File.open(request_file)

    if request_method == "GET"
      client.puts("HTTP/1.0 200 OK \r\nDate: #{Time.now.ctime} \r\nContent-Type: text/html \r\nContent-Length: #{File.size(file)} \r\n\r\n#{file.read}")
    elsif request_method == "POST"
      request_body = ""
      while line = client.gets
      	request_body << line
      	break if request_body =~/\r\n\r\n$/
      end
      request_body = request_body.chomp.chomp

      params = JSON.parse(request_body)
      data = "<li>Name: #{params['viking']['name']}</li><li>Email: #{params['viking']['email']}</li>"
      client.puts("HTTP/1.0 200 OK \r\nDate: #{Time.now.ctime} \r\nContent-Type: text/html \r\nContent-Length: #{File.size(file)} \r\n\r\n")
      client.puts file.read.gsub('<%= yield %>', data)
    else
      client.puts("HTTP/1.0 404 Bad Request \r\nDate: #{time.now.ctime}")
    end

  else
  	client.puts("HTTP/1.0 404 Not Found \r\nDate: #{time.now.ctime}")
  end

  client.close

}