# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::PostsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #feed" do
    before(:each) do
      34.times { create(:minimal_article, :published) }
      34.times { create(:minimal_review,  :published) }
      34.times { create(:minimal_mixtape, :published) }
    end

    it "renders last 100 published posts as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:posts)).to have(100).items
    end
  end
end
