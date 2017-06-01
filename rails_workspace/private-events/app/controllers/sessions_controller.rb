class SessionsController < ApplicationController
  def new

  end

  def create
  	@user = User.find_by(params[:username])
  	if @user
  		log_in @user
  		redirect_to @user
  	else
  		flash.now[:warning] = "Try again please"
  		render new_user_path
  	end
  end

  def destroy
  	log_out if logged_in?
  	redirect_to login_path
  end
end
