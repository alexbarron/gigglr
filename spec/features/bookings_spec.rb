require 'rails_helper'

describe 'Bookings' do

	context 'as an admin' do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@admin = create(:admin)
				sign_in(@admin)
			end
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			@comedian = create(:comedian)
		end
		scenario 'add a comedian to a show' do
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end

			click_link @show.name

			select @comedian.name, from: 'booking[comedian_id]'
			click_button 'Add Comedian'

			expect(page).to have_content 'Comedian added to show'

		end
		scenario 'removes a comedian from a show' do
			booking = create(:booking, comedian_id: @comedian.id, show_id: @show.id)
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name

			click_button 'Remove Comedian'

			expect(page).to have_content 'Comedian removed from show'
			
		end
	end

	context 'as a user' do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@user = create(:user)
				sign_in(@user)
			end
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			@comedian = create(:comedian)
		end

		scenario 'cannot see add comedian button' do
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(page).not_to have_button 'Add Comedian'
		end

		scenario 'cannot see remove comedian button' do
			booking = create(:booking, comedian_id: @comedian.id, show_id: @show.id)
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(page).not_to have_button 'Remove Comedian'
		end
	end

	context 'as a guest' do
		before :each do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			@comedian = create(:comedian)
		end	
		scenario 'cannot see add comedian button' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(page).not_to have_button 'Add Comedian'
		end
		scenario 'cannot see remove comedian button' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(page).not_to have_button 'Remove Comedian'
		end
	end
end