require 'rails_helper'

RSpec.describe ComediansController, :type => :controller do

  shared_examples 'public access to comedians' do
    describe "GET index" do
      it "renders :index template" do
        get :index
        expect(response).to render_template :index
      end
      it "returns array of comedians" do
        comedian1 = create(:comedian)
        comedian2 = create(:comedian)
        booking = create(:booking, comedian_id: comedian1.id)
        get :index
        expect(assigns(:comedians)).to match_array [comedian1]
      end
    end
    describe "GET show" do
      it "assigns the requested comedian to @comedian" do
        @comedian = create(:comedian)
        get :show, id: @comedian
        expect(assigns(:comedian)).to eq @comedian
      end
      it "renders :show template" do
        comedian = create(:comedian)
        get :show, id: comedian
        expect(response).to render_template :show
      end
    end
  end

  describe 'guest access' do
    it_behaves_like 'public access to comedians'

    describe 'GET #new' do
      it 'requires login' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        comedian = create(:comedian)
        get :edit, id: comedian
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:comedian),
          comedian: attributes_for(:comedian)
        expect(response).to require_login
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:comedian),
         comedian: attributes_for(:comedian)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it 'requires login' do
        delete :destroy, id: create(:comedian)
        expect(response).to require_login
      end
    end
  end

  describe 'user access' do
    before :each do
      VCR.use_cassette("create user and sign in") do
        @user = create(:user)
        sign_in(@user)
      end
    end

    it_behaves_like 'public access to comedians'

    describe 'GET #new' do
      it 'redirects to root' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to root' do
        comedian = create(:comedian)
        get :edit, id: comedian
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to root' do
        post :create, id: create(:comedian),
          comedian: attributes_for(:comedian)
        expect(response).to redirect_to root_path
      end
      it 'does not save comedian' do
        expect{
          post :create, comedian: attributes_for(:comedian)
        }.not_to change(Comedian, :count)
      end
    end

    describe 'PUT #update' do
      it 'redirects to root' do
        put :update, id: create(:comedian),
         comedian: attributes_for(:comedian)
        expect(response).to redirect_to root_path
      end
      it 'does not change comedian' do
        comedian = create(:comedian)
        put :update, id: comedian,
          comedian: attributes_for(:comedian,
            name:'Mr. Fakename')
        comedian.reload
        expect(comedian.name).not_to eq('Mr. Fakename')
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @comedian = create(:comedian)
      end
      it 'redirects to root' do
        delete :destroy, id: @comedian
        expect(response).to redirect_to root_path
      end
      it 'does not delete the comedian' do
        expect{
          delete :destroy, id: @comedian
        }.not_to change(Comedian, :count)
      end
    end
  end

  describe 'admin access' do
    before :each do
      VCR.use_cassette("create user and sign in") do
        @admin = create(:admin)
        sign_in(@admin)
      end
    end
    it_behaves_like 'public access to comedians'

    describe "GET new" do
      it "assigns a new Comedian to comedian" do
        get :new
        expect(assigns(:comedian)).to be_a_new(Comedian)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do
      context "with valid attributes" do
        it "saves the new comedian in the database" do
          expect{
            post :create, comedian: attributes_for(:comedian)
          }.to change(Comedian, :count).by(1)
        end

        it "redirects to :show template" do
          post :create, comedian: attributes_for(:comedian)
          expect(response).to redirect_to comedian_path(assigns[:comedian])
        end
      end

      context "with invalid attributes" do
        it "does not save the new comedian in the database" do
          expect{
            post :create, comedian: attributes_for(:invalid_comedian)
          }.not_to change(Comedian, :count)
        end

        it "re-renders :new template" do
          post :create, comedian: attributes_for(:invalid_comedian)
          expect(response).to render_template :new
        end
      end
    end

    describe "GET edit" do
      it "renders :edit template" do
        comedian = create(:comedian)
        get :edit, id: comedian
        expect(response).to have_http_status(:success)
      end
    end

    describe "PATCH update" do
      before :each do
        @comedian = create(:comedian, name: "Jim Jefferies")
      end
      context "valid attributes" do
        it "locates the requested comedian" do
          patch :update, id: @comedian, comedian: attributes_for(:comedian)
          expect(assigns(:comedian)).to eq(@comedian)
        end
        it "changes @comedian's attributes" do
          patch :update, id: @comedian,
            comedian: attributes_for(:comedian,
              name: "James Jefferies")
          @comedian.reload
          expect(@comedian.name).to eq('James Jefferies')
        end
        it "redirects to the updated comedian" do
          patch :update, id: @comedian, comedian: attributes_for(:comedian)
          expect(response).to redirect_to @comedian
        end
      end
      context "invalid attributes" do
        it "does not change the comedian's attributes" do
          patch :update, id: @comedian,
            comedian: attributes_for(:comedian,
              name: nil)
          @comedian.reload
          expect(@comedian.name).to eq @comedian.name
        end
        it "re-renders the :edit template" do
          patch :update, id: @comedian,
            comedian: attributes_for(:invalid_comedian)
          expect(response).to render_template :edit
        end
      end
    end

    describe "DELETE destroy" do
      before :each do
        @comedian = create(:comedian)
      end
      it "redirects to :index" do
        delete :destroy, id: @comedian
        expect(response).to redirect_to comedians_path
      end
      it "deletes the comedian" do
        expect{
          delete :destroy, id: @comedian
        }.to change(Comedian, :count).by(-1)
      end
    end
  end
end
