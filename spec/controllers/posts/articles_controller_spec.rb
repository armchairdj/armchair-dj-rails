# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::ArticlesController do
  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:article) { create(:minimal_article, :published) }

    it "renders" do
      get :show, params: { slug: article.slug }

      is_expected.to successfully_render("posts/articles/show")

      expect(assigns(:article)).to eq(article)
    end
  end
end
