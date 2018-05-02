require "rails_helper"

RSpec.describe Admin::MediaController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Medium. As you add validations to Admin::Medium, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      medium = Admin::Medium.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      medium = Admin::Medium.create! valid_params
      get :show, params: {id: medium.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it "renders" do
      get :new, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Admin::Medium" do
        expect {
          post :create, params: {medium: valid_params}, session: valid_session
        }.to change(Admin::Medium, :count).by(1)
      end

      it "redirects to the created medium" do
        post :create, params: {medium: valid_params}, session: valid_session
        expect(response).to redirect_to(Admin::Medium.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "new" template)" do
        post :create, params: {medium: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      medium = Admin::Medium.create! valid_params
      get :edit, params: {id: medium.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested medium" do
        medium = Admin::Medium.create! valid_params
        put :update, params: {id: medium.to_param, medium: new_attributes}, session: valid_session
        medium.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the medium" do
        medium = Admin::Medium.create! valid_params
        put :update, params: {id: medium.to_param, medium: valid_params}, session: valid_session
        expect(response).to redirect_to(medium)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "edit" template)" do
        medium = Admin::Medium.create! valid_params
        put :update, params: {id: medium.to_param, medium: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested medium" do
      medium = Admin::Medium.create! valid_params
      expect {
        delete :destroy, params: {id: medium.to_param}, session: valid_session
      }.to change(Admin::Medium, :count).by(-1)
    end

    it "redirects to the media list" do
      medium = Admin::Medium.create! valid_params
      delete :destroy, params: {id: medium.to_param}, session: valid_session
      expect(response).to redirect_to(media_url)
    end
  end

end
