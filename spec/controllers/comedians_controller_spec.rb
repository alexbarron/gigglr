require 'rails_helper'

RSpec.describe ComediansController, :type => :controller do

  describe "GET index" do
    it "renders :index template" do
      get :index
      expect(response).to render_template :index
    end
    it "returns array of comedians" do
      comedian1 = create(:comedian)
      comedian2 = create(:comedian)
      get :index
      expect(assigns(:comedians)).to match_array [comedian1, comedian2]
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
    it "redirect to :index" do
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
