class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @shows = []
    @city = ""

    if params[:locsearch]
      user_loc = Geocoder.search(params[:locsearch]).first
      @city = user_loc.city + ', ' + user_loc.state_code
      venues = Venue.near(params[:locsearch], 50)
    elsif current_user
      @city = current_user.city + ', ' + current_user.state
      venues = Venue.near(current_user.location, current_user.distance_pref)
    else
      local_ip = ENV['IP_DEV_VAR']
      ip = Rails.env.development? || Rails.env.test? ? local_ip : request.remote_ip
      user_loc = Geocoder.search(ip).first
      @city = user_loc.city + ', ' + user_loc.state_code
      #@city = "Los Angeles, CA"
      #venues = Venue.near(@city, 50)
      venues = Venue.near(user_loc.postal_code, 50)
    end
    venue_ids = venues.map(&:id)
    @shows = Show.where('showtime > ? AND venue_id IN (?)', Time.now, venue_ids).order("showtime ASC")
  end

  def show
    @full_lineup = @show.comedians.sort { |b,a| a.users.count <=> b.users.count }
    @comedians = Comedian.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
    @full_lineup.each do |x|
      @comedians.delete(x)
    end
    @headliner = @full_lineup.first
    @openers = @full_lineup.clone
    @openers.delete(@headliner)
  end

  def new
    @show = Show.new
    @venues = Venue.all
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      redirect_to shows_url, notice: 'Successfully created show'
    else
      render 'new'
    end
  end

  def edit
    @venues = Venue.all
  end

  def update
    if @show.update(show_params)
      redirect_to @show, notice: 'Successfully updated show'
    else
      render 'edit'
    end
  end

  def destroy
    @show.destroy
    redirect_to shows_url, notice: 'Successfully deleted show'
  end

  private

  def set_show
    @show = Show.find(params[:id])
  end

  def show_params
    params.require(:show).permit(:name, :description, :showtime, :venue_id)
  end
end
