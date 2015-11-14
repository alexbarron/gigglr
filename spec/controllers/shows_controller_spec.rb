require 'rails_helper'

RSpec.describe ShowsController, :type => :controller, focus: true do

  shared_examples 'logged in access to shows' do
    describe 'GET index' do
      it 'renders the :index template' do
        VCR.use_cassette("user visits shows index") do
          get :index
        end
        expect(response).to render_template :index
      end
      it 'returns an array of shows' do
        VCR.use_cassette("create_show") do
          @show1 = create(:show)
        end
        VCR.use_cassette("create_show") do
            @show2 = create(:show)
        end
        VCR.use_cassette("user visits shows index") do
          get :index
        end
        expect(assigns[:shows]).to match_array [@show1, @show2]
      end
    end

    describe 'GET show' do
      it 'renders the :show template' do
        show = create(:show)
        get :show, id: show
        expect(response).to render_template :show
      end
      it 'assigns the requested show to @show' do
        @show = create(:show)
        get :show, id: @show
        expect(assigns(:show)).to eq @show
      end
    end
  end

  describe 'guest access' do
    describe 'GET index' do
      it 'renders the :index template' do
        VCR.use_cassette("guest visits shows index") do
          get :index
        end
        expect(response).to render_template :index
      end
      it 'returns an array of shows' do
        VCR.use_cassette("create_show") do
          @show1 = create(:show)
        end
        VCR.use_cassette("create_show") do
            @show2 = create(:show)
        end
        VCR.use_cassette("guest visits shows index") do
          get :index
        end
        expect(assigns[:shows]).to match_array [@show1, @show2]
      end
    end

    describe 'GET show' do
      it 'renders the :show template' do
        show = create(:show)
        get :show, id: show
        expect(response).to render_template :show
      end
      it 'assigns the requested show to @show' do
        @show = create(:show)
        get :show, id: @show
        expect(assigns(:show)).to eq @show
      end
    end

    describe 'GET #new' do
      it 'requires login' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        show = create(:show)
        get :edit, id: show
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:show),
          show: attributes_for(:show)
        expect(response).to require_login
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:show),
         show: attributes_for(:show)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      it 'requires login' do
        delete :destroy, id: create(:show)
        expect(response).to require_login
      end
    end
  end

  describe 'user access' do
    before :each do
      @user = create(:user)
      sign_in(@user)
    end
    it_behaves_like 'logged in access to shows'

    describe 'GET #new' do
      it 'redirects to root' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'redirects to root' do
        show = create(:show)
        get :edit, id: show
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'redirects to root' do
        post :create, id: create(:show),
          show: attributes_for(:show, venue_id: 1)
        expect(response).to redirect_to root_path
      end
      it 'does not save show' do
        expect{
          post :create, show: attributes_for(:show)
        }.not_to change(Show, :count)
      end
    end

    describe 'PUT #update' do
      it 'redirects to root' do
        put :update, id: create(:show),
         show: attributes_for(:show)
        expect(response).to redirect_to root_path
      end
      it 'does not change show' do
        show = create(:show)
        put :update, id: show,
          show: attributes_for(:show, name: "Fake Show")
        show.reload
        expect(show.name).not_to eq('Fake Show')
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @show = create(:show)
      end
      it 'redirects to root' do
        delete :destroy, id: @show
        expect(response).to redirect_to root_path
      end
      it 'does not delete the show' do
        expect{
          delete :destroy, id: @show
        }.not_to change(Show, :count)
      end
    end
  end

  describe 'admin access' do
    before :each do
      @admin = create(:admin)
      sign_in(@admin)
    end
    it_behaves_like 'logged in access to shows'

    describe 'GET new' do
      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
      it 'assigns a new show to show' do
        get :new
        expect(assigns(:show)).to be_a_new(Show)
      end
    end

    describe 'POST create' do
      context 'with valid attributes' do
        it 'saves the new show to the database' do
          expect{
            post :create, show: attributes_for(:show, venue_id: 1)
          }.to change(Show, :count).by(1)
        end
        it 'redirects to show template' do
          post :create, show: attributes_for(:show, venue_id: 1)
          expect(response).to redirect_to shows_url
        end
      end

      context 'with invalid attributes' do
        it "does not save invalid show to database" do
          expect{
            post :create, show: attributes_for(:invalid_show)
          }.not_to change(Show, :count)
        end
        it "re-renders the new template" do
          post :create, show: attributes_for(:invalid_show)
          expect(response).to render_template :new
        end
      end
    end

    describe 'GET edit' do
      before :each do
        @show = create(:show)
      end
      it 'renders the :edit template' do
        get :edit, id: @show
        expect(response).to render_template :edit
      end
      it 'assigns the requested show to @show' do
        get :edit, id: @show
        expect(assigns(:show)).to eq @show
      end
    end

    describe 'PATCH update' do
      before :each do
        @show = create(:show, name: "Last Comic Standing Tour")
      end
      context 'with valid attributes' do
        it 'locates the requested show' do
          patch :update, id: @show, show: attributes_for(:show)
          expect(assigns(:show)).to eq @show
        end
        it "changes @show's attributes" do
          patch :update, id: @show, show: attributes_for(:show, 
            name: "Chris Rock in San Francisco")
          @show.reload
          expect(@show.name).to eq("Chris Rock in San Francisco")
        end
        it "redirects to @show" do
          patch :update, id: @show, show: attributes_for(:show)
          expect(response).to redirect_to @show
        end
      end

      context 'with invalid attributes' do
        it "does not change @show's attributes" do
          patch :update, id: @show, show: attributes_for(:show,
            name: "Bill Burr with friends",
            venue_id: nil)
          @show.reload
          expect(@show.name).to eq "Last Comic Standing Tour"
        end
        it "re-renders :edit template" do
          patch :update, id: @show, show: attributes_for(:invalid_show)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE destroy' do
      before :each do
        @show = create(:show)
      end
      it 'redirects to :index template' do
        delete :destroy, id: @show
        expect(response).to redirect_to shows_path
      end
      it 'deletes the show' do
        expect{
          delete :destroy, id: @show
        }.to change(Show, :count).by(-1)
      end
    end
  end
end
