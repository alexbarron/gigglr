require 'rails_helper'

feature 'Comedians' do
	shared_examples 'logged in view of comedians' do
		scenario "access comedian show page from comedian index" do
			comedian = create(:comedian)
			booking = create(:booking, comedian_id: comedian.id)
			click_link 'Comedians'
			expect(page).to have_content comedian.name
			click_link comedian.name
			expect(current_path).to eq comedian_path(comedian.id)
			expect(page).to have_content comedian.name
		end
	end

	shared_examples 'non-admin view of comedians' do
		scenario 'cannot see add comedian link' do
			visit root_path
			click_link 'Comedians'
			expect(page).not_to have_link 'Add comedian'
		end
		scenario 'cannot see edit or delete comedian link' do
			comedian = create(:comedian)
			visit root_path
			click_link 'Comedians'
			click_link comedian.name
			expect(page).not_to have_link 'Edit Comedian'
			expect(page).not_to have_link 'Delete'
		end
	end

	context "as an admin" do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@admin = create(:admin)
				sign_in(@admin)
			end
		end
		it_behaves_like 'logged in view of comedians'

		scenario "adds a comedian" do
			click_link "Comedians"
			expect(page).not_to have_content "Louis CK"
			click_link 'New Comedian'
			fill_in "Name", with: "Louis CK"
			fill_in "Description", with: "A raunchy comedian from Boston"
			click_button "Submit"
			expect(page).to have_content "Louis CK"
			expect(page).to have_content "A raunchy comedian from Boston"
			expect(page).to have_content "Comedian added successfully"
		end

		scenario 'edits a comedian' do
			comedian = create(:comedian)
			visit comedian_path(comedian)
			click_link 'Edit'
			fill_in 'Name', with: 'Jerry Seinfeld'
			fill_in 'Description', with: 'From the hit TV show Seinfeld.'
			click_button 'Submit'
			expect(current_path).to eq comedian_path(comedian)
			expect(page).to have_content 'Jerry Seinfeld'
			expect(page).to have_content 'From the hit TV show Seinfeld.'
			expect(page).to have_content "Comedian updated successfully"
		end

		scenario 'deletes a comedian' do
			comedian = create(:comedian)
			visit comedian_path(comedian)
			click_link 'Delete'
			expect(current_path).to eq comedians_path
			expect(page).not_to have_content comedian.name
			expect(page).to have_content "Comedian deleted successfully"
		end
	end

	context "as a user" do
		before :each do
			VCR.use_cassette("create user and sign in") do
				@user = create(:user)
				sign_in(@user)
			end
		end

		it_behaves_like 'logged in view of comedians'
		
		scenario 'cannot see add comedian link' do
			click_link 'Comedians'
			expect(page).not_to have_link 'Add comedian'
		end
		scenario 'cannot see edit or delete comedian link' do
			comedian = create(:comedian)
			visit comedian_path(comedian)
			expect(page).not_to have_link 'Edit Comedian'
			expect(page).not_to have_link 'Delete'
		end
	end

	context "as a guest" do
		scenario "access comedian show page from comedian index" do
			comedian = create(:comedian)
			booking = create(:booking, comedian_id: comedian.id)
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Comedians'
			expect(page).to have_content comedian.name
			click_link comedian.name
			expect(current_path).to eq comedian_path(comedian.id)
			expect(page).to have_content comedian.name
		end

		scenario 'cannot see add comedian link' do
			VCR.use_cassette("guest visits shows index") do
				visit root_path
			end
			click_link 'Comedians'
			expect(page).not_to have_link 'Add comedian'
		end
		scenario 'cannot see edit or delete comedian link' do
			comedian = create(:comedian)
			visit comedian_path(comedian)
			expect(page).not_to have_link 'Edit Comedian'
			expect(page).not_to have_link 'Delete'
		end
	end

end