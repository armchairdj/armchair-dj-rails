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
    context "without records" do
      it "renders" do
        get :index

        is_expected.to successfully_render("playlists/index")
        expect(assigns(:playlists)).to paginate(0).of_total_records(0)
      end
    end

    context "with records" do
      before(:each) do
        21.times { create(:mixtape, :published) }
      end

      it "renders" do
        get :index

        is_expected.to successfully_render("playlists/index")
        expect(assigns(:playlists)).to paginate(20).of_total_records(21)
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        is_expected.to successfully_render("playlists/index")
        expect(assigns(:playlists)).to paginate(1).of_total_records(21)
      end
    end
  end

  describe "GET #show" do
    let(:playlist) { create(:minimal_playlist, :with_published_post) }

    it "renders" do
        get :show, params: { slug: playlist.slug }

        is_expected.to successfully_render("playlists/show")

        expect(assigns(:playlist)).to eq(playlist)
    end
  end
end
