class ComediansController < ApplicationController
  before_action :set_comedian, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    if params[:search]
      @comedians = Comedian.search(params[:search])
    else
      @comedians = Comedian.all.sort { |b,a| a.users.count <=> b.users.count }
    end
  end

  def show
    @shows = @comedian.shows.where("showtime > ?", Time.now).sort { |a,b| a.showtime <=> b.showtime }
  end

  def new
    @comedian = Comedian.new
  end

  def create
    @comedian = Comedian.new(comedian_params)
    if @comedian.save
      redirect_to @comedian, notice: 'Comedian added successfully' 
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @comedian.update(comedian_params)
      redirect_to @comedian, notice: 'Comedian updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @comedian.destroy
    redirect_to comedians_url, notice: 'Comedian deleted successfully'
  end

  private

  def set_comedian
    @comedian = Comedian.find(params[:id])
  end

  def comedian_params
    params.require(:comedian).permit(:name, :description, :picture)
  end
end
