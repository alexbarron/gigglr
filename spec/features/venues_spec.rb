require 'rails_helper'

describe 'Venues' do
	shared_examples 'logged in view of venues' do
		scenario "access venue page from venue index" do
			venue = create(:venue, id: 1)
			show = create(:show, name: "Louis CK In Santa Monica", venue_id: 1)
			click_link 'Venues'
			expect(page).to have_content venue.name
			click_link venue.name
			expect(current_path).to eq venue_path(venue.id)
			expect(page).to have_content venue.name
			expect(page).to have_content venue.full_address
			expect(page).to have_content "Louis CK In Santa Monica"
		end
	end

	context 'as an admin' do
		before :each do
			@admin = create(:admin)
			VCR.use_cassette("user signs in") do
				sign_in(@admin)
			end
		end
		it_behaves_like 'logged in view of venues'

		scenario 'adds a venue' do
			click_link 'Venues'
			click_link 'Add venue'

			fill_in 'Name', with: 'Laugh Factory'
			fill_in 'Street address', with: '123 Main Street'
			fill_in 'City', with: 'Los Angeles'
			fill_in 'State', with: 'CA'
			fill_in 'Zip', with: '12345'
			
			VCR.use_cassette("add a venue form") do
				click_button 'Submit'
			end

			expect(current_path).to eq venues_path
			expect(page).to have_content 'Successfully created venue'
			expect(page).to have_content 'Laugh Factory'
			expect(page).to have_content 'Los Angeles'
		end

		scenario 'edits a venue' do
			venue = create(:venue)
			click_link 'Venues'
			expect(page).to have_content venue.name
			expect(page).to have_content venue.city
			click_link venue.name
			expect(current_path).to eq venue_path(venue)
			click_link 'Edit Venue'
			fill_in 'Name', with: 'Comedy Store'
			fill_in 'City', with: 'Hollywood'
			click_button 'Submit'
			expect(current_path).to eq venue_path(venue)
			expect(page).to have_content 'Comedy Store'
			expect(page).to have_content 'Hollywood'
		end

		scenario 'deletes a venue' do
			venue = create(:venue)
			click_link 'Venues'
			click_link venue.name
			expect(current_path).to eq venue_path(venue)
			click_link 'Delete'
			expect(current_path).to eq venues_path
			expect(page).not_to have_content venue.name
		end
	end

	context 'as a user' do
		before :each do
			@user = create(:user)
			VCR.use_cassette("user signs in") do
				sign_in(@user)
			end
		end
		it_behaves_like 'logged in view of venues'

		scenario 'cannot see add venue link' do
			click_link 'Venues'
			expect(page).not_to have_link 'Add venue'
		end

		scenario 'cannot see edit or delete venue link' do
			venue = create(:venue)
			click_link 'Venues'
			click_link venue.name
			expect(page).not_to have_link 'Edit Venue'
			expect(page).not_to have_link 'Delete'
		end

	end

	context 'as a guest' do

		scenario "access venue page from venue index" do
			venue = create(:venue, id: 1)
			show = create(:show, name: "Louis CK In Santa Monica", venue_id: 1)
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Venues'
			expect(page).to have_content venue.name
			click_link venue.name
			expect(current_path).to eq venue_path(venue.id)
			expect(page).to have_content venue.name
			expect(page).to have_content venue.full_address
			expect(page).to have_content "Louis CK In Santa Monica"
		end

		scenario 'cannot see add venue link' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Venues'
			expect(page).not_to have_link 'Add venue'
		end

		scenario 'cannot see edit or delete venue link' do
			venue = create(:venue)
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Venues'
			click_link venue.name
			expect(page).not_to have_link 'Edit Venue'
			expect(page).not_to have_link 'Delete'
		end
	end


end