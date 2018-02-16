class FavoritesController < ApplicationController
  before_action :authenticate_user! 
  
  def create
    @event = Event.find(params[:event_id])
    @favorite = current_user.favorites.build(event: @event)
    if @favorite.save
      redirect_to events_path, notice: 'Event saved to your favorites'
    else
      redirect_to events_path, alert: 'Event could not be saved to your favorites'
    end
  end

  def destroy
    @favorite = current_user.favorites.find_by(event_id: params[:event_id])
    @favorite.destroy
    redirect_to events_path, notice: 'Event removed from your favorites'
  end
end
