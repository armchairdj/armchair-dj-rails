# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { articles_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:article) { create(:minimal_article, :published) }

    it "renders" do
      get :show, params: { slug: article.slug }

      is_expected.to successfully_render("articles/show")

      expect(assigns(:article)).to eq(article)
    end
  end

  describe "GET #feed" do
    before(:each) do
      101.times { create(:minimal_article, :published) }
    end

    it "renders last 100 published articles as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:articles)).to have(100).items
    end
  end
end
