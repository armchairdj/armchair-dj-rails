# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { playlists_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:playlist) { create(:minimal_playlist, :with_published_post) }

    it "renders" do
        get :show, params: { id: playlist.to_param }

        is_expected.to successfully_render("playlists/show")

        expect(assigns(:playlist)).to eq(playlist)
    end
  end
end
