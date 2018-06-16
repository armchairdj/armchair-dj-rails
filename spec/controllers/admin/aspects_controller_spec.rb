require "rails_helper"

RSpec.describe Admin::AspectsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Aspect. As you add validations to Aspect, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:bad_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      aspect = Aspect.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      aspect = Aspect.create! valid_params
      get :show, params: {id: aspect.to_param}, session: valid_session
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
      it "creates a new Aspect" do
        expect {
          post :create, params: {admin_aspect: valid_params}, session: valid_session
        }.to change(Aspect, :count).by(1)
      end

      it "redirects to the created admin_aspect" do
        post :create, params: {admin_aspect: valid_params}, session: valid_session
        expect(response).to redirect_to(Aspect.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'new' template)" do
        post :create, params: {admin_aspect: bad_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      aspect = Aspect.create! valid_params
      get :edit, params: {id: aspect.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_aspect" do
        aspect = Aspect.create! valid_params
        put :update, params: {id: aspect.to_param, admin_aspect: new_attributes}, session: valid_session
        aspect.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the admin_aspect" do
        aspect = Aspect.create! valid_params
        put :update, params: {id: aspect.to_param, admin_aspect: valid_params}, session: valid_session
        expect(response).to redirect_to(aspect)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'edit' template)" do
        aspect = Aspect.create! valid_params
        put :update, params: {id: aspect.to_param, admin_aspect: bad_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested admin_aspect" do
      aspect = Aspect.create! valid_params
      expect {
        delete :destroy, params: {id: aspect.to_param}, session: valid_session
      }.to change(Aspect, :count).by(-1)
    end

    it "redirects to the aspects list" do
      aspect = Aspect.create! valid_params
      delete :destroy, params: {id: aspect.to_param}, session: valid_session
      expect(response).to redirect_to(admin_aspects_url)
    end
  end

end
