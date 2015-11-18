class BookingsController < ApplicationController
	before_action :admin_user

	def create
		added_comedian = Comedian.find(params[:booking][:comedian_id])
		@show = Show.find(params[:booking][:show_id])
		if @show.book_comedian(added_comedian)
			@show.notify_fans_of(added_comedian, @show)
		end
		redirect_to @show, notice: 'Comedian added to show'
	end

	def destroy
		@booking = Booking.find(params[:id])
		@show = @booking.show
		@show.unbook_comedian(@booking.comedian)
		redirect_to @show, notice: 'Comedian removed from show'
	end


end