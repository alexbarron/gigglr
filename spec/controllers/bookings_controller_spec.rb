require 'rails_helper'

RSpec.describe BookingsController, :type => :controller do
	shared_examples 'public view of bookings' do
		before :each do
			@comedian = create(:comedian)
			@show = create(:show)
		end
		describe 'POST #create' do
			it 'redirects to root' do
				post :create, booking: attributes_for(:booking, comedian_id: @comedian.id, show_id: @show.id)
				expect(response).to redirect_to root_path
			end
		end
		describe 'DELETE #destroy' do
			it 'redirects to root' do
				@booking = create(:booking)
				delete :destroy, id: @booking
				expect(response).to redirect_to root_path
			end
		end
	end

	describe 'guest access' do
		it_behaves_like 'public view of bookings'
	end

	describe 'user access' do
		before :each do
			VCR.use_cassette("create user and sign in") do
        		@user = create(:user)
        		sign_in(@user)
      		end
		end
		it_behaves_like 'public view of bookings'
	end

	describe 'admin access' do
		before :each do
			@comedian = create(:comedian)
			@show = create(:show)
			VCR.use_cassette("create user and sign in") do
        		@admin = create(:admin)
        		sign_in(@admin)
      		end
		end
		describe 'POST #create' do
			it 'saves the new booking to the database' do
				expect{
					post :create, booking: attributes_for(:booking, comedian_id: @comedian.id, show_id: @show.id)
				}.to change(Booking, :count).by(1)
			end
			it 'redirects to @show' do
				post :create, booking: attributes_for(:booking, comedian_id: @comedian.id, show_id: @show.id)
				expect(response).to redirect_to @show
			end
		end
		describe 'DELETE #destroy' do
			before :each do
				@booking = create(:booking, show_id: @show.id, comedian_id: @comedian.id)
			end
			it 'deletes the booking' do
				expect{
					delete :destroy, id: @booking, show_id: @show.id, comedian_id: @comedian.id
				}.to change(Booking, :count).by(-1)
			end
			it 'redirects to @show' do
				delete :destroy, id: @booking, show_id: @show.id, comedian_id: @comedian.id
				expect(response).to redirect_to @show
			end
		end
	end

end