class ComediansController < ApplicationController
  before_action :set_comedian, only: [:show, :edit, :update, :destroy, :update_ticketmaster_shows]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :add_ticketmaster_comedian, :update_ticketmaster_shows, :update_comedians_shows]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :add_ticketmaster_comedian, :update_ticketmaster_shows, :update_comedians_shows]
  
  def index
    if params[:search]
      @comedians = Comedian.search(params[:search])
      Analytics.track(
        user_id: current_user.id,
        event: 'Searched Comedian',
        properties: { query: params[:search] })
    else
      @comedians = Comedian.all_with_shows_and_users
      Analytics.track(
        user_id: current_user.id,
        event: 'Viewed Comedians Index')
    end
  end

  def show
    @shows = @comedian.future_shows
    if !!current_user
      Analytics.track(
        user_id: current_user.id,
        event: 'Viewed Comedian',
        properties: { comedian: @comedian.name, comedian_id: @comedian.id })
    end
  end

  def new
    @comedian = Comedian.new
  end

  def create
    @comedian = Comedian.new(comedian_params)
    if @comedian.save
      Analytics.track(
        user_id: current_user.id,
        event: 'Created Comedian',
        properties: { comedian: @comedian.name, comedian_id: @comedian.id })
      redirect_to @comedian, notice: 'Comedian added successfully' 
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @comedian.update(comedian_params)
      Analytics.track(
        user_id: current_user.id,
        event: 'Updated Comedian',
        properties: { comedian: @comedian.name, comedian_id: @comedian.id })
      redirect_to @comedian, notice: 'Comedian updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @comedian.destroy
    redirect_to comedians_url, notice: 'Comedian deleted successfully'
  end

  def ticketmaster_search
    if params[:name]
      Analytics.track(
        user_id: current_user.id,
        event: 'Searched Ticketmaster Comedians')
      @results = Comedian.search_ticketmaster(params[:name])
    else
      @results = []
    end
  end

  def add_ticketmaster_comedian
    @comedian = Comedian.add_ticketmaster_comedian(params[:ticketmaster_id])
    Analytics.track(
        user_id: current_user.id,
        event: 'Added Comedian from Ticketmaster',
        properties: { comedian: @comedian.name, comedian_id: @comedian.id })
    redirect_to @comedian
  end

  def update_ticketmaster_shows
    @comedian.add_shows
    redirect_to @comedian
  end

  def update_comedians_shows
    Comedian.update_comedians_shows
    redirect_to comedians_path, notice: "Successfully updated all comedians' shows"
  end

  private

  def set_comedian
    @comedian = Comedian.find(params[:id])
  end

  def comedian_params
    params.require(:comedian).permit(:name, :description, :picture)
  end
end
