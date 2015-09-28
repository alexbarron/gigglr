class ComediansController < ApplicationController
  before_action :set_comedian, only: [:show, :edit, :update, :destroy]

  def index
    @comedians = Comedian.all
  end

  def show
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
    params.require(:comedian).permit(:name, :description)
  end
end
