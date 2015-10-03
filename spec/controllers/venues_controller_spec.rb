require 'rails_helper'

RSpec.describe VenuesController, :type => :controller do

  shared_examples 'public access to venues' do
    describe "GET index" do
      it "renders :index template" do
        get :index
        expect(response).to render_template :index
      end
      it "returns array of venues" do
        venue1 = create(:venue)
        venue2 = create(:venue)
        get :index
        expect(assigns(:venues)).to match_array [venue1, venue2]
      end
    end
    describe "GET show" do
      it "assigns the requested venue to @venue" do
        @venue = create(:venue)
        get :show, id: @venue
        expect(assigns(:venue)).to eq @venue
      end
      it "renders :show template" do
        venue = create(:venue)
        get :show, id: venue
        expect(response).to render_template :show
      end
    end
  end

  describe 'guest access' do
    it_behaves_like 'public access to venues'

    describe 'GET #new' do
      it 'requires login' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        venue = create(:venue)
        get :edit, id: venue
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:venue),
          venue: attributes_for(:venue)
        expect(response).to require_login
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:venue),
         venue: attributes_for(:venue)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it 'requires login' do
        delete :destroy, id: create(:venue)
        expect(response).to require_login
      end
    end
  end

  describe 'user access' do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end

    it_behaves_like 'public access to venues'

    describe 'GET #new' do
      it 'redirects to root' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to root' do
        venue = create(:venue)
        get :edit, id: venue
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to root' do
        post :create, id: create(:venue),
          venue: attributes_for(:venue)
        expect(response).to redirect_to root_path
      end
      it 'does not save venue' do
        expect{
          post :create, venue: attributes_for(:venue)
        }.not_to change(Venue, :count)
      end
    end

    describe 'PUT #update' do
      it 'redirects to root' do
        put :update, id: create(:venue),
         venue: attributes_for(:venue)
        expect(response).to redirect_to root_path
      end
      it 'does not change venue' do
        venue = create(:venue)
        put :update, id: venue,
          venue: attributes_for(:venue,
            name:'Mr. Fakename')
        venue.reload
        expect(venue.name).not_to eq('Mr. Fakename')
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @venue = create(:venue)
      end
      it 'redirects to root' do
        delete :destroy, id: @venue
        expect(response).to redirect_to root_path
      end
      it 'does not delete the venue' do
        expect{
          delete :destroy, id: @venue
        }.not_to change(Venue, :count)
      end
    end
  end

  describe 'admin access' do
    before :each do
      @admin = create(:admin)
      sign_in(@admin)
    end
    it_behaves_like 'public access to venues'

    describe "GET new" do
      it "assigns a new venue to venue" do
        get :new
        expect(assigns(:venue)).to be_a_new(Venue)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "saves the new venue in the database" do
          expect{
            post :create, venue: attributes_for(:venue)
          }.to change(Venue, :count).by(1)
        end

        it "redirects to :show template" do
          post :create, venue: attributes_for(:venue)
          expect(response).to redirect_to venue_path(assigns[:venue])
        end
      end

      context "with invalid attributes" do
        it "does not save the new venue in the database" do
          expect{
            post :create, venue: attributes_for(:invalid_venue)
          }.not_to change(Venue, :count)
        end

        it "re-renders :new template" do
          post :create, venue: attributes_for(:invalid_venue)
          expect(response).to render_template :new
        end
      end
    end

    describe "GET edit" do
      it "renders :edit template" do
        venue = create(:venue)
        get :edit, id: venue
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH update" do
      before :each do
        @venue = create(:venue, name: "Comedy Store")
      end
      context "valid attributes" do
        it "locates the requested venue" do
          patch :update, id: @venue, venue: attributes_for(:venue)
          expect(assigns(:venue)).to eq(@venue)
        end
        it "changes @venue's attributes" do
          patch :update, id: @venue,
            venue: attributes_for(:venue,
              name: "Comedy Factory")
          @venue.reload
          expect(@venue.name).to eq('Comedy Factory')
        end
        it "redirects to the updated venue" do
          patch :update, id: @venue, venue: attributes_for(:venue)
          expect(response).to redirect_to @venue
        end
      end
      context "invalid attributes" do
        it "does not change the venue's attributes" do
          patch :update, id: @venue,
            venue: attributes_for(:venue,
              name: nil)
          @venue.reload
          expect(@venue.name).to eq @venue.name
        end
        it "re-renders the :edit template" do
          patch :update, id: @venue,
            venue: attributes_for(:invalid_venue)
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      before :each do
        @venue = create(:venue)
      end
      it "redirect to :index" do
        delete :destroy, id: @venue
        expect(response).to redirect_to venues_path
      end
      it "deletes the venue" do
        expect{
          delete :destroy, id: @venue
        }.to change(Venue, :count).by(-1)
      end
    end
  end
end
