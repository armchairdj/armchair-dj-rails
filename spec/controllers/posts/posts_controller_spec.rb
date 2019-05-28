# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::PostsController do
  it_behaves_like "a_paginatable_controller"

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #feed" do
    before do
      create_list(:minimal_article, 34, :published)
      create_list(:minimal_review, 34, :published)
      create_list(:minimal_mixtape, 34, :published)
    end

    it "renders last 100 published posts as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:posts)).to have(100).items
    end
  end
end
