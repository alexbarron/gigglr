require 'rails_helper'

describe 'Venues' do
	shared_examples 'public view of venues' do
		scenario "access venue page from venue index" do
			venue = create(:venue)
			visit root_path
			click_link 'Venues'
			expect(page).to have_content venue.name
			click_link venue.name
			expect(current_path).to eq venue_path(venue.id)
			expect(page).to have_content venue.name
			expect(page).to have_content venue.address.full_address
		end
	end

	shared_examples 'non-admin view of venues' do
		scenario 'cannot see add venue link' do
			visit root_path
			click_link 'Venues'
			expect(page).not_to have_link 'Add venue'
		end
		scenario 'cannot see edit or delete venue link' do
			venue = create(:venue)
			visit root_path
			click_link 'Venues'
			click_link venue.name
			expect(page).not_to have_link 'Edit'
			expect(page).not_to have_link 'Delete'
		end
	end

	context 'as an admin' do
		before :each do
			@admin = create(:admin)
			sign_in(@admin)
		end
		it_behaves_like 'public view of venues'

		scenario 'adds a venue' do
			visit root_path
			click_link 'Venues'

			expect(page).not_to have_content 'Laugh Factory'
			click_link 'Add venue'

			fill_in 'Name', with: 'Laugh Factory'
			fill_in 'Street address', with: '123 Main Street'
			fill_in 'City', with: 'Los Angeles'
			fill_in 'State', with: 'CA'
			fill_in 'Zip', with: '12345'
			click_button 'Submit'

			expect(current_path).to eq venues_path
			expect(page).to have_content 'Successfully created venue'
			expect(page).to have_content 'Laugh Factory'
			expect(page).to have_content 'Los Angeles'
		end

		scenario 'edits a venue' do
			venue = create(:venue)
			visit root_path
			click_link 'Venues'
			expect(page).to have_content venue.name
			expect(page).to have_content venue.address.city
			click_link venue.name
			expect(current_path).to eq venue_path(venue)
			click_link 'Edit'
			fill_in 'Name', with: 'Comedy Store'
			fill_in 'City', with: 'Hollywood'
			click_button 'Submit'
			expect(current_path).to eq venue_path(venue)
			expect(page).to have_content 'Comedy Store'
			expect(page).to have_content 'Hollywood'
		end

		scenario 'deletes a venue' do
			venue = create(:venue)
			visit root_path
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
			sign_in(@user)
		end
		it_behaves_like 'public view of venues'
		it_behaves_like 'non-admin view of venues'


	end

	context 'as a guest' do
		it_behaves_like 'public view of venues'
		it_behaves_like 'non-admin view of venues'
	end


end