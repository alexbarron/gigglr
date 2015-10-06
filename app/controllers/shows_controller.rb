class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]

  def index
    @shows = Show.all
  end

  def show
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
    redirect_to shows_url
  end

  private

  def set_show
    @show = Show.find(params[:id])
  end

  def show_params
    params.require(:show).permit(:name, :description, :showtime, :venue_id)
  end
end
