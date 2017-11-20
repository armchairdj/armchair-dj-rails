require 'rails_helper'

RSpec.describe SongsController, type: :controller do

  let(:valid_attributes) { {
    title: "Song Title",
    artist_id: create(:minimal_artist).id
  } }

  let(:invalid_attributes) { {
    title: "",
    artist_id: nil
  } }

  describe "GET #index" do
    let(:songs) { [
      create(:minimal_song),
      create(:minimal_song)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success
    end
  end

  describe "GET #show" do
    let(:song) {
      create(:minimal_song)
    }

    it "returns a success response" do
      get :show, params: {id: song.to_param}

      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}

      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Song" do
        expect {
          post :create, params: {song: valid_attributes}
        }.to change(Song, :count).by(1)
      end

      it "redirects to the created song" do
        post :create, params: {song: valid_attributes}

        expect(response).to redirect_to(Song.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {song: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    let(:song) {
      create(:minimal_song)
    }

    it "returns a success response" do
      get :edit, params: {id: song.to_param}

      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    let(:song) {
      create(:minimal_song)
    }

    context "with valid params" do
      let(:new_attributes) { {
        title: "New Song Title"
      } }

      it "updates the requested song" do
        put :update, params: {id: song.to_param, song: new_attributes}

        song.reload

        expect(song.title).to eq(new_attributes[:title])
      end

      it "redirects to the song" do
        put :update, params: {id: song.to_param, song: valid_attributes}

        expect(response).to redirect_to(song)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: song.to_param, song: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:song) {
      create(:minimal_song)
    }

    it "destroys the requested song" do
      expect {
        delete :destroy, params: {id: song.to_param}
      }.to change(Song, :count).by(-1)
    end

    it "redirects to the songs list" do
      delete :destroy, params: {id: song.to_param}

      expect(response).to redirect_to(songs_url)
    end
  end

end
