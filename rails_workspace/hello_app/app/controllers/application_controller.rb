class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
  	render html: "hello, world!"
  end

  def hola
  	render html: "¡Hola, Mundo!"
  end

  def goodbye
  	render html: "Goodbye World"
  end
end
