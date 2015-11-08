class VenuesController < ApplicationController
  before_action :set_venue, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  def index
    @venues = Venue.all
  end

  def show
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save
      redirect_to venues_url, notice: 'Successfully created venue'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: 'Venue updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @venue.destroy
    redirect_to venues_url, notice: 'Comedian deleted successfully'
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def venue_params
    params.require(:venue).permit(:name, :street_address, :city, :state, :zip)
  end
end
