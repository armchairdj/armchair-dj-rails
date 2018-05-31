require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Playlist. As you add validations to Playlist, be sure to
  # adjust the attributes here as well.
  let(:valid_params) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_params) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "renders" do
      playlist = Playlist.create! valid_params
      get :index, params: {}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "renders" do
      playlist = Playlist.create! valid_params
      get :show, params: {id: playlist.to_param}, session: valid_session
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
      it "creates a new Playlist" do
        expect {
          post :create, params: {admin_playlist: valid_params}, session: valid_session
        }.to change(Playlist, :count).by(1)
      end

      it "redirects to the created admin_playlist" do
        post :create, params: {admin_playlist: valid_params}, session: valid_session
        expect(response).to redirect_to(Playlist.last)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'new' template)" do
        post :create, params: {admin_playlist: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET #edit" do
    it "renders" do
      playlist = Playlist.create! valid_params
      get :edit, params: {id: playlist.to_param}, session: valid_session
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested admin_playlist" do
        playlist = Playlist.create! valid_params
        put :update, params: {id: playlist.to_param, admin_playlist: new_attributes}, session: valid_session
        playlist.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the admin_playlist" do
        playlist = Playlist.create! valid_params
        put :update, params: {id: playlist.to_param, admin_playlist: valid_params}, session: valid_session
        expect(response).to redirect_to(playlist)
      end
    end

    context "with invalid params" do
      it "renders (i.e. to display the 'edit' template)" do
        playlist = Playlist.create! valid_params
        put :update, params: {id: playlist.to_param, admin_playlist: invalid_params}, session: valid_session
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested admin_playlist" do
      playlist = Playlist.create! valid_params
      expect {
        delete :destroy, params: {id: playlist.to_param}, session: valid_session
      }.to change(Playlist, :count).by(-1)
    end

    it "redirects to the playlists list" do
      playlist = Playlist.create! valid_params
      delete :destroy, params: {id: playlist.to_param}, session: valid_session
      expect(response).to redirect_to(admin_playlists_url)
    end
  end

end
