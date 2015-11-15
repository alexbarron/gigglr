require 'rails_helper'

describe 'Shows' do
	shared_examples 'logged in view of shows' do
		scenario "access show page from show index" do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(current_path).to eq show_path(@show.id)
			expect(page).to have_content @show.name
			expect(page).to have_content @show.showtime
			expect(page).to have_content @show.description
			expect(page).to have_content @show.venue.name
			expect(page).to have_content @show.venue.full_address
		end
	end

	context 'as an admin' do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@admin = create(:admin)
				sign_in(@admin)
			end
		end
		it_behaves_like 'logged in view of shows'

		scenario 'adds a show' do
			VCR.use_cassette("create venue") do
				@venue = create(:venue)
			end
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link 'Add show'

			fill_in 'Name', with: 'Bill Burr in Los Angeles'
			fill_in 'Description', with: 'A great night of laughs with Bill Burr'
			select '2015', from: 'show[showtime(1i)]'
			select 'December', from: 'show[showtime(2i)]'
			select '10', from: 'show[showtime(3i)]'
			select '20', from: 'show[showtime(4i)]'
			select '00', from: 'show[showtime(5i)]'
			select "Alejandro's Comedy Shop", from: 'show[venue_id]'
			
			VCR.use_cassette("add a show form") do
				click_button 'Submit'
			end
			expect(current_path).to eq shows_path
			expect(page).to have_content 'Successfully created show'
			expect(page).to have_content "12/10 Alejandro's Comedy Shop"
		end

		scenario 'edits a show' do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
      		VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(current_path).to eq show_path(@show)
			click_link 'Edit Show'
			fill_in 'Name', with: 'Jim Jefferies in SF'
			fill_in 'Description', with: 'Australian comedian comes to San Francisco'
			select '2015', from: 'show[showtime(1i)]'
			select 'December', from: 'show[showtime(2i)]'
			select '29', from: 'show[showtime(3i)]'
			select '20', from: 'show[showtime(4i)]'
			select '00', from: 'show[showtime(5i)]'
			click_button 'Submit'
			expect(current_path).to eq show_path(@show)
			expect(page).to have_content 'Successfully updated show'
			expect(page).to have_content 'Jim Jefferies in SF'
			expect(page).to have_content 'Australian comedian comes to San Francisco'
			expect(page).to have_content '2015-12-29 20:00:00'
		end

		scenario 'deletes a show' do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
      		VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(current_path).to eq show_path(@show)
			VCR.use_cassette("delete a show") do
				click_link 'Delete'
			end
			expect(current_path).to eq shows_path
			expect(page).to have_content 'Successfully deleted show'
			expect(page).not_to have_content "#{@show.showtime.strftime('%m/%-d')} #{@show.venue.name}"
		end
	end

	context 'as a user' do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@user = create(:user)
				sign_in(@user)
			end
		end

		it_behaves_like 'logged in view of shows'

		scenario 'cannot see add show link' do
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			expect(page).not_to have_link 'Add show'
		end

		scenario 'cannot see edit or delete show link' do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			#show = create(:show)
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			#click_link 'Shows'
			click_link @show.name
			expect(page).not_to have_link 'Edit Show'
			expect(page).not_to have_link 'Delete'
		end


	end

	context 'as a guest' do

		scenario "access show page from show index" do
      		VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end

			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(current_path).to eq show_path(@show.id)
			expect(page).to have_content @show.name
			expect(page).to have_content @show.showtime
			expect(page).to have_content @show.description
			expect(page).to have_content @show.venue.name
			expect(page).to have_content @show.venue.full_address
		end

		scenario 'cannot see add show link' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			expect(page).not_to have_link 'Add show'
		end

		scenario 'cannot see edit or delete show link' do
			VCR.use_cassette("create_show") do
        		@show = create(:show)
      		end
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link @show.name
			expect(page).not_to have_link 'Edit Show'
			expect(page).not_to have_link 'Delete'
		end
	end
end