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
      get :show, params: { id: article.to_param }

      is_expected.to successfully_render("articles/show")

      expect(assigns(:article)).to eq(article)
    end
  end
end
