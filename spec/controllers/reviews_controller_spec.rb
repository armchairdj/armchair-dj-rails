# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { reviews_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:review) { create(:minimal_review, :with_published_post) }

    it "renders" do
        get :show, params: { slug: review.slug }

        is_expected.to successfully_render("reviews/show")

        expect(assigns(:review)).to eq(review)
    end
  end
end
