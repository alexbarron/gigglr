require 'rails_helper'

feature 'Comedians' do
	context "as an admin" do
		scenario "adds a comedian" do
			admin = create(:admin)
			sign_in(admin)
			click_link "Comedians"
			expect(page).not_to have_content "Louis CK"
			click_link 'Add comedian'
			fill_in "Name", with: "Louis CK"
			fill_in "Description", with: "A raunchy comedian from Boston"
			click_button "Create Comedian"
			expect(page).to have_content "Louis CK"
			expect(page).to have_content "A raunchy comedian from Boston"
			expect(page).to have_content "Comedian added successfully"
		end
	end

	context "as a user" do
		scenario "cannot see add comedian link" do
			user = create(:user)
			sign_in(user)
			click_link "Comedians"
			expect(page).not_to have_link "Add comedian"
		end
	end

	context "as a guest" do
		scenario "cannot see add comedian link" do
			visit root_path
			click_link "Comedians"
			expect(page).not_to have_link "Add comedian"
		end
	end

	scenario "looks at a comedian's page" do
		comedian = create(:comedian)
		visit root_path
		click_link "Comedians"
		expect(page).to have_content comedian.name
		click_link comedian.name
		expect(current_path).to eq comedian_path(comedian.id)
		expect(page).to have_content comedian.name
		expect(page).to have_content comedian.description
	end

end