require "rails_helper"

RSpec.describe Admin::RolesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Role. As you add validations to Admin::Role, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      role = Admin::Role.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      role = Admin::Role.create! valid_params
      get :show, params: {id: role.to_param}, session: valid_session
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
      it "creates a new Admin::Role" do
        expect {
          post :create, params: {role: valid_params}, session: valid_session
        }.to change(Admin::Role, :count).by(1)
      end

      it "redirects to the created role" do
        post :create, params: {role: valid_params}, session: valid_session
        expect(response).to redirect_to(Admin::Role.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'new' template)" do
        post :create, params: {role: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      role = Admin::Role.create! valid_params
      get :edit, params: {id: role.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested role" do
        role = Admin::Role.create! valid_params
        put :update, params: {id: role.to_param, role: new_attributes}, session: valid_session
        role.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the role" do
        role = Admin::Role.create! valid_params
        put :update, params: {id: role.to_param, role: valid_params}, session: valid_session
        expect(response).to redirect_to(role)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'edit' template)" do
        role = Admin::Role.create! valid_params
        put :update, params: {id: role.to_param, role: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested role" do
      role = Admin::Role.create! valid_params
      expect {
        delete :destroy, params: {id: role.to_param}, session: valid_session
      }.to change(Admin::Role, :count).by(-1)
    end

    it "redirects to the roles list" do
      role = Admin::Role.create! valid_params
      delete :destroy, params: {id: role.to_param}, session: valid_session
      expect(response).to redirect_to(roles_url)
    end
  end

end
