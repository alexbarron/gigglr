require 'rails_helper'

describe 'Shows' do
	shared_examples 'public view of shows' do
		scenario "access show page from show index" do
			show = create(:show)
			visit root_path
			click_link 'Shows'
			expect(page).to have_content "#{show.name}: #{show.showtime} at #{show.venue.name}"
			click_link "#{show.name}: #{show.showtime} at #{show.venue.name}"
			expect(current_path).to eq show_path(show.id)
			expect(page).to have_content show.name
			expect(page).to have_content show.showtime
			expect(page).to have_content show.description
			expect(page).to have_content show.venue.name
			expect(page).to have_content show.venue.full_address
		end
	end

	shared_examples 'non-admin view of shows' do
		scenario 'cannot see add show link' do
			visit root_path
			click_link 'Shows'
			expect(page).not_to have_link 'Add show'
		end
		scenario 'cannot see edit or delete show link' do
			show = create(:show)
			visit root_path
			click_link 'Shows'
			click_link show.name
			expect(page).not_to have_link 'Edit Show'
			expect(page).not_to have_link 'Delete'
		end
	end

	context 'as an admin' do
		before :each do
			@admin = create(:admin)
			sign_in(@admin)
		end
		it_behaves_like 'public view of shows'

		scenario 'adds a show' do
			venue = create(:venue, name: "Hollywood Improv")
			visit root_path
			click_link 'Shows'
			click_link 'Add show'

			fill_in 'Name', with: 'Bill Burr at the Hollywood Improv'
			fill_in 'Description', with: 'A great night of laughs with Bill Burr'
			select '2015', from: 'show[showtime(1i)]'
			select 'October', from: 'show[showtime(2i)]'
			select '10', from: 'show[showtime(3i)]'
			select '20', from: 'show[showtime(4i)]'
			select '00', from: 'show[showtime(5i)]'
			select "Hollywood Improv", from: 'show[venue_id]'
			click_button 'Submit'

			expect(current_path).to eq shows_path
			expect(page).to have_content 'Successfully created show'
			expect(page).to have_content 'Bill Burr at the Hollywood Improv'
			expect(page).to have_content '2015-10-10 20:00:00'
		end

		scenario 'edits a show' do
			show = create(:show)
			venue = create(:venue, name: 'The Punchline SF')
			visit root_path
			click_link 'Shows'
			expect(page).to have_content show.name
			click_link show.name
			expect(current_path).to eq show_path(show)
			click_link 'Edit Show'
			fill_in 'Name', with: 'Jim Jefferies at the Punchline'
			fill_in 'Description', with: 'Australian comedian comes to San Francisco'
			select '2015', from: 'show[showtime(1i)]'
			select 'October', from: 'show[showtime(2i)]'
			select '10', from: 'show[showtime(3i)]'
			select '20', from: 'show[showtime(4i)]'
			select '00', from: 'show[showtime(5i)]'
			select "The Punchline SF", from: 'show[venue_id]'
			click_button 'Submit'
			expect(current_path).to eq show_path(show)
			expect(page).to have_content 'Successfully updated show'
			expect(page).to have_content 'Jim Jefferies at the Punchline'
			expect(page).to have_content 'Australian comedian comes to San Francisco'
			expect(page).to have_content '2015-10-10 20:00:00'
			expect(page).to have_content "The Punchline SF"
		end

		scenario 'deletes a show' do
			show = create(:show)
			visit root_path
			click_link 'Shows'
			click_link show.name
			expect(current_path).to eq show_path(show)
			click_link 'Delete'
			expect(current_path).to eq shows_path
			expect(page).not_to have_content show.name
		end
	end

	context 'as a user' do
		before :each do
			@user = create(:user)
			sign_in(@user)
		end
		it_behaves_like 'public view of shows'
		it_behaves_like 'non-admin view of shows'


	end

	context 'as a guest' do
		it_behaves_like 'public view of shows'
		it_behaves_like 'non-admin view of shows'
	end


end