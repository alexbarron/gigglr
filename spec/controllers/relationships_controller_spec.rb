require 'rails_helper'

RSpec.describe RelationshipsController, :type => :controller do
	before :each do
		@comedian = create(:comedian)
		VCR.use_cassette("create user") do
			@user = create (:user)
		end
	end
	describe 'user access' do
		before :each do
			VCR.use_cassette("user signs in") do
				sign_in(@user)
			end
		end
		describe 'POST #create' do
			it 'saves the new relationship to the database' do
				expect{
					post :create, comedian_id: @comedian.id
				}.to change(Relationship, :count).by(1)
			end
			it 'redirects to @comedian' do
				post :create, comedian_id: @comedian.id
				expect(response).to redirect_to @comedian
			end
		end
		describe 'DELETE #destroy' do
			before :each do
				@relationship = create(:relationship, user_id: @user.id, comedian_id: @comedian.id)
			end
			it 'deletes the booking' do
				expect{
					delete :destroy, id: @relationship
				}.to change(Relationship, :count).by(-1)
			end
			it 'redirects to @comedian' do
				delete :destroy, id: @relationship
				expect(response).to redirect_to @comedian
			end
		end
	end

	describe 'guest access' do
		describe 'POST #create' do
			it 'requires login' do
				post :create, relationship: attributes_for(:relationship, comedian_id: @comedian.id, user_id: @user.id)
				expect(response).to require_login
			end
		end
		describe 'DELETE #destroy' do
			it 'requires login' do
				@relationship = create(:relationship, user_id: @user.id, comedian_id: @comedian.id)
				delete :destroy, id: @relationship
				expect(response).to require_login
			end
		end
	end
end