require 'rails_helper'

RSpec.describe ShowsController, :type => :controller, focus: true do

  shared_examples 'public access to shows' do
    describe 'GET index' do
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
      it 'returns an array of shows' do
        show1 = create(:show)
        show2 = create(:show)
        get :index
        expect(assigns[:shows]).to match_array [show1, show2]
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

  end

  describe 'user access' do

  end

  describe 'admin access' do
    it_behaves_like 'public access to shows'

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
