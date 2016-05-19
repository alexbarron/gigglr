class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    if params[:locsearch]
      location = Geocoder.search(params[:locsearch]).first
      @city = location.city + ', ' + location.state_code
    elsif current_user
      @city = current_user.city + ', ' + current_user.state
    else
      ip = Rails.env.development? || Rails.env.test? ? '167.187.101.240' : request.remote_ip
      location = Geocoder.search(ip).first
      @city = location.city + ', ' + location.region
    end
    distance_pref = current_user ? current_user.distance_pref : 50
    @shows = Show.nearby(@city, distance_pref)
  end

  def show
    @lineup = @show.comedians.order("fan_count DESC")
    @comedians = Comedian.order("name ASC") - @lineup
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
