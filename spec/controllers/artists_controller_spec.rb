require 'rails_helper'

RSpec.describe ArtistsController, type: :controller do

  let(:valid_attributes) { {
    name: "Kate Bush"
  } }

  let(:invalid_attributes) { {
    name: ""
  } }

  describe 'GET #index' do
    let(:artists) { [
      create(:minimal_artist),
      create(:minimal_artist)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success

      expect(assigns(:artists)).to match_array(artists)
    end
  end

  describe 'GET #show' do
    let(:artist) {
      create(:minimal_artist)
    }

    it "returns a success response" do
      get :show, params: {id: artist.to_param}

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
      it "creates a new Artist" do
        expect {
          post :create, params: {artist: valid_attributes}
        }.to change(Artist, :count).by(1)
      end

      it "redirects to the created artist" do
        post :create, params: {artist: valid_attributes}

        expect(response).to redirect_to(Artist.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {artist: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    let(:artist) {
      create(:minimal_artist)
    }

    it "returns a success response" do
      get :edit, params: {id: artist.to_param}

      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    let(:artist) {
      create(:minimal_artist)
    }

    context "with valid params" do
      let(:new_attributes) { {
        name: "Updated name"
      } }

      it "updates the requested artist" do
        put :update, params: { id: artist.to_param, artist: new_attributes}

        artist.reload

        expect(artist.name).to eq(new_attributes[:name])
      end

      it "redirects to the artist" do
        put :update, params: {id: artist.to_param, artist: valid_attributes}

        expect(response).to redirect_to(artist)
      end
    end

    context "with invalid params" do
      it "returns a success response" do
        put :update, params: {id: artist.to_param, artist: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:artist) {
      create(:minimal_artist)
    }

    it "destroys the requested artist" do
      expect {
        delete :destroy, params: {id: artist.to_param}
      }.to change(Artist, :count).by(-1)
    end

    it "redirects to the artists list" do
      delete :destroy, params: {id: artist.to_param}

      expect(response).to redirect_to(artists_url)
    end
  end
end
