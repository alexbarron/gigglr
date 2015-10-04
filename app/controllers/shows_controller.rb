class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]

  def index
    @shows = Show.all
  end

  def show
  end

  def new
    @show = Show.new
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      redirect_to shows_url, notice: 'Show added successfully'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @show.update(show_params)
      redirect_to @show, notice: 'Show updated successfully'
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
