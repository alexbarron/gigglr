class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @shows = []
    @city = ""
    if current_user
      user_loc = Geocoder.search(current_user.location).first
      @city = user_loc.city + ', ' + user_loc.state_code
      #@city = "Los Angeles, CA"
      venues = Venue.near(current_user.location, current_user.distance_pref)
      venues.each do |venue|
        Show.where("venue_id = ? AND showtime > ?", venue.id, Time.now).each do |show|
          @shows.push(show)
        end
      end
    else
      ip = Rails.env.development? || Rails.env.test? ? '76.219.223.26' : request.remote_ip
      user_loc = Geocoder.search(ip).first
      @city = user_loc.city + ', ' + user_loc.state_code
      #@city = "Los Angeles, CA"
      venues = Venue.near(user_loc.postal_code, 50)
      venues.each do |venue|
        Show.where("venue_id = ? AND showtime > ?", venue.id, Time.now).each do |show|
          @shows.push(show)
        end
      end
    end
    @shows.sort! { |a,b| a.showtime <=> b.showtime }
  end

  def show
    @booked_comedians = @show.comedians
    @comedians = Comedian.all.sort { |a,b| a.name.downcase <=> b.name.downcase }
    @booked_comedians.each do |x|
      @comedians.delete(x)
    end
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
