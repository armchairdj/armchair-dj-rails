require "rails_helper"

RSpec.describe Admin::GenresController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Genre. As you add validations to Admin::Genre, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      genre = Admin::Genre.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      genre = Admin::Genre.create! valid_params
      get :show, params: {id: genre.to_param}, session: valid_session
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
      it "creates a new Admin::Genre" do
        expect {
          post :create, params: {admin_genre: valid_params}, session: valid_session
        }.to change(Admin::Genre, :count).by(1)
      end

      it "redirects to the created admin_genre" do
        post :create, params: {admin_genre: valid_params}, session: valid_session
        expect(response).to redirect_to(Admin::Genre.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "new" template)" do
        post :create, params: {admin_genre: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      genre = Admin::Genre.create! valid_params
      get :edit, params: {id: genre.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_genre" do
        genre = Admin::Genre.create! valid_params
        put :update, params: {id: genre.to_param, admin_genre: new_attributes}, session: valid_session
        genre.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the admin_genre" do
        genre = Admin::Genre.create! valid_params
        put :update, params: {id: genre.to_param, admin_genre: valid_params}, session: valid_session
        expect(response).to redirect_to(genre)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the "edit" template)" do
        genre = Admin::Genre.create! valid_params
        put :update, params: {id: genre.to_param, admin_genre: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested admin_genre" do
      genre = Admin::Genre.create! valid_params
      expect {
        delete :destroy, params: {id: genre.to_param}, session: valid_session
      }.to change(Admin::Genre, :count).by(-1)
    end

    it "redirects to the admin_genres list" do
      genre = Admin::Genre.create! valid_params
      delete :destroy, params: {id: genre.to_param}, session: valid_session
      expect(response).to redirect_to(admin_genres_url)
    end
  end

end
