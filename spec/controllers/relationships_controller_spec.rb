require 'rails_helper'

RSpec.describe RelationshipsController, :type => :controller do
	before :each do
		@comedian = create(:comedian)
		@user = create (:user)
	end
	describe 'correct user access' do
		before :each do
			sign_in(@user)
		end
		describe 'POST #create' do
			it 'saves the new relationship to the database' do
				expect{
					post :create, relationship: attributes_for(:relationship, comedian_id: @comedian.id, user_id: @user.id)
				}.to change(Relationship, :count).by(1)
			end
			it 'redirects to @comedian' do
				post :create, relationship: attributes_for(:relationship, comedian_id: @comedian.id, user_id: @user.id)
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

	describe 'incorrect user access' do
		before :each do
			@wrong_user = create(:user)
			sign_in(@wrong_user)
		end
		describe 'POST #create' do
			it 'does not save the relationship to the database' do
				expect{
					post :create, relationship: attributes_for(:relationship, comedian_id: @comedian.id, user_id: @user.id)
				}.not_to change(Relationship, :count)
			end

			it 'redirects to root' do
				post :create, relationship: attributes_for(:relationship, comedian_id: @comedian.id, user_id: @user.id)
				expect(response).to redirect_to root_url
			end
		end

		describe 'DELETE #destroy' do
			before :each do
				@relationship = create(:relationship, user_id: @user.id, comedian_id: @comedian.id)
			end
			it 'does not delete the relationship' do
				expect{
					delete :destroy, id: @relationship
				}.not_to change(Relationship, :count)
			end
			it 'redirects to @comedian' do
				delete :destroy, id: @relationship
				expect(response).to redirect_to root_url
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
				@relationship = create(:relationship)
				delete :destroy, id: @relationship
				expect(response).to require_login
			end
		end
	end
end