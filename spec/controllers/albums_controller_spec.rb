require 'rails_helper'

RSpec.describe AlbumsController, type: :controller do

  let(:valid_attributes) { {
    title: "Album Title",
    artist_id: create(:minimal_artist).id
  } }

  let(:invalid_attributes) { {
    title: "",
    artist_id: nil
  } }

  describe 'GET #index' do
    let(:albums) { [
      create(:minimal_album),
      create(:minimal_album)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:album) {
      create(:minimal_album)
    }

    it "returns a success response" do
      get :show, params: {id: album.to_param}

      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it "returns a success response" do
      get :new, params: {}

      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context "with valid params" do
      it "creates a new Album" do
        expect {
          post :create, params: {album: valid_attributes}
        }.to change(Album, :count).by(1)
      end

      it "redirects to the created album" do
        post :create, params: {album: valid_attributes}

        expect(response).to redirect_to(Album.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {album: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    let(:album) {
      create(:minimal_album)
    }

    it "returns a success response" do
      get :edit, params: {id: album.to_param}

      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    let(:album) {
      create(:minimal_album)
    }

    context "with valid params" do
      let(:new_attributes) { {
        title: "New Album Title"
      } }

      it "updates the requested album" do
        put :update, params: {id: album.to_param, album: new_attributes}

        album.reload

        expect(album.title).to eq(new_attributes[:title])
      end

      it "redirects to the album" do
        put :update, params: {id: album.to_param, album: valid_attributes}

        expect(response).to redirect_to(album)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: album.to_param, album: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:album) {
      create(:minimal_album)
    }

    it "destroys the requested album" do
      expect {
        delete :destroy, params: {id: album.to_param}
      }.to change(Album, :count).by(-1)
    end

    it "redirects to the albums list" do
      delete :destroy, params: {id: album.to_param}

      expect(response).to redirect_to(albums_url)
    end
  end

end
