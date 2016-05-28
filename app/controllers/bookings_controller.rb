class BookingsController < ApplicationController
	before_action :admin_user

	def create
		added_comedian = Comedian.find(params[:booking][:comedian_id])
		@show = Show.find(params[:booking][:show_id])
		if @show.book_comedian(added_comedian)
			@show.delay.notify_fans_of(added_comedian, @show)
		end
    Analytics.track(
      user_id: current_user.id,
      event: 'Booked Comedian for Show',
      properties: { comedian: added_comedian.name, comedian_id: added_comedian.id, show_name: @show.name, show_id: @show.id })
		redirect_to @show, notice: 'Comedian added to show'
	end

	def destroy
		@booking = Booking.find_by(show_id: params[:show_id], comedian_id: params[:comedian_id])
		@show = @booking.show
		@show.unbook_comedian(@booking.comedian)
    Analytics.track(
      user_id: current_user.id,
      event: 'Unbooked Comedian for Show',
      properties: { comedian: @booking.comedian.name, comedian_id: @booking.comedian.id, show_name: @show.name, show_id: @show.id })
		redirect_to @show, notice: 'Comedian removed from show'
	end


end