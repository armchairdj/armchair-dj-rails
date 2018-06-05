# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { posts_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:post) { create(:minimal_post, :published) }

    it "renders" do
      get :show, params: { slug: post.slug }

      is_expected.to successfully_render("posts/show")

      expect(assigns(:post)).to eq(post)
    end
  end

  describe "GET #feed" do
    before(:each) do
      101.times { create(:minimal_post, :published) }
    end

    it "renders last 100 published posts as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:posts)).to have(100).items
    end
  end
end
