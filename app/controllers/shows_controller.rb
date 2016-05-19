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
      local_ip = '167.187.101.240'
      ip = Rails.env.development? || Rails.env.test? ? local_ip : request.remote_ip
      user_loc = Geocoder.search(ip).first
      @city = user_loc.city + ', ' + user_loc.state_code
      #@city = "Los Angeles, CA"
      #venues = Venue.near(@city, 50)
      venues = Venue.near(user_loc.postal_code, 50)
    end
    venue_ids = venues.map(&:id)
    @shows = Show.where('showtime > ? AND venue_id IN (?)', Time.now, venue_ids).includes(:comedians, :venue).order("showtime ASC").limit(20)
  end

  def show
    @full_lineup = @show.comedians.order("fan_count DESC")
    @comedians = Comedian.order("name ASC") - @full_lineup
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
