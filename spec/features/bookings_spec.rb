require 'rails_helper'

describe 'Bookings' do
	shared_examples 'public view of bookings' do
		before :each do
			@venue = create(:venue)
			@show = create(:show, name: 'Bill Burr & Friends on a Friday night', venue_id: @venue.id)
			@comedian = create(:comedian)
		end	
		scenario 'cannot see add comedian button' do
			visit root_path
			click_link 'Shows'
			click_link 'Bill Burr & Friends on a Friday night'
			expect(page).not_to have_button 'Add Comedian'
		end
		scenario 'cannot see remove comedian button' do
			visit root_path
			click_link 'Shows'
			click_link 'Bill Burr & Friends on a Friday night'
			expect(page).not_to have_button 'Remove Comedian'
		end
	end

	context 'as a guest' do
		it_behaves_like 'public view of bookings'
	end

	context 'as a user' do
		before :each do
			@user = create(:user)
			sign_in(@user)
		end
		it_behaves_like 'public view of bookings'
	end
	context 'as an admin' do
		before :each do
			@admin = create(:admin)
			sign_in(@admin)
			@venue = create(:venue)
			@show = create(:show, name: 'Bill Burr & Friends on a Friday night', venue_id: @venue.id)
			@comedian = create(:comedian)
		end
		scenario 'add a comedian to a show' do
			visit root_path
			click_link 'Shows'
			click_link 'Bill Burr & Friends on a Friday night'

			select @comedian.name, from: 'booking[comedian_id]'
			click_button 'Add Comedian'

			expect(page).to have_content 'Comedian added to show'

		end
		scenario 'removes a comedian from a show' do
			booking = create(:booking, comedian_id: @comedian.id, show_id: @show.id)
			visit root_path
			click_link 'Shows'
			click_link 'Bill Burr & Friends on a Friday night'

			click_button 'Remove Comedian'

			expect(page).to have_content 'Comedian removed from show'
			
		end
	end
end