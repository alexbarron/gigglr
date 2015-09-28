require 'rails_helper'

feature 'Comedians' do

	scenario "adds a comedian" do
		visit root_path
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