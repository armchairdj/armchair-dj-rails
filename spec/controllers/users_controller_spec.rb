require "rails_helper"

RSpec.describe UsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:bad_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      user = User.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      user = User.create! valid_params
      get :show, params: {id: user.to_param}, session: valid_session
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
      it "creates a new User" do
        expect {
          post :create, params: {user: valid_params}, session: valid_session
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: {user: valid_params}, session: valid_session
        expect(response).to redirect_to(User.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'new' template)" do
        post :create, params: {user: bad_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      user = User.create! valid_params
      get :edit, params: {id: user.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user" do
        user = User.create! valid_params
        put :update, params: {id: user.to_param, user: new_attributes}, session: valid_session
        user.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the user" do
        user = User.create! valid_params
        put :update, params: {id: user.to_param, user: valid_params}, session: valid_session
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'edit' template)" do
        user = User.create! valid_params
        put :update, params: {id: user.to_param, user: bad_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      user = User.create! valid_params
      expect {
        delete :destroy, params: {id: user.to_param}, session: valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = User.create! valid_params
      delete :destroy, params: {id: user.to_param}, session: valid_session
      expect(response).to redirect_to(users_url)
    end
  end

end
