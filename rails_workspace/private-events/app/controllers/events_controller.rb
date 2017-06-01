class EventsController < ApplicationController
  def new
  	@event = Event.new
  end

  def create
  	if @event = current_user.events.create(event_params)
  		flash[:sucess] = "You created an event!"
  		redirect_to events_show_path
  	else
  		flash.now[:danger] = "Try again"
  		render events_new_path
  	end
  end

  def show
  	@event = Event.find_by(params[:id])
  end

  def index
  	@events = Event.all
  end

  private

    def event_params
    	params.require(:event).permit(:name, :place, :day, :desc)
    end
end
