require 'rails_helper'

describe 'Relationships' do
	before :each do
		@comedian = create(:comedian, name: 'Chris Rock')
	end
	context 'as a guest' do
		scenario 'clicking follow redirects to login' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Comedians'
			click_link 'Chris Rock'
			click_button 'Follow'

			expect(current_path).to eq new_user_session_path
		end
	end

	context 'as a user' do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@user = create(:user)
				sign_in(@user)
			end
		end
		scenario 'follows a comedian from comedian show page' do
			click_link 'Comedians'
			click_link 'Chris Rock'
			expect(page).to have_content '(0 Fans)'
			click_button 'Follow'

			expect(current_path).to eq comedian_path(@comedian)
			expect(page).to have_button 'Unfollow'
			expect(page).to have_content "You're now following #{@comedian.name}"
			expect(page).to have_content '(1 Fan)'
		end

		scenario 'unfollows a comedian from comedian show page' do
			relationship = create(:relationship, comedian_id: @comedian.id, user_id: @user.id)
			VCR.use_cassette("user visits shows index") do
				visit root_path
			end
			click_link 'Comedians'
			click_link 'Chris Rock'
			expect(page).to have_content '(1 Fan)'
			click_button 'Unfollow'

			expect(current_path).to eq comedian_path(@comedian)
			expect(page).to have_button 'Follow'
			expect(page).to have_content "You're no longer following #{@comedian.name}"
			expect(page).to have_content '(0 Fans)'
		end
	end

end