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
    let(:review) { create(:minimal_review, :published) }

    it "renders" do
        get :show, params: { id: review.to_param }

        is_expected.to successfully_render("reviews/show")

        expect(assigns(:review)).to eq(review)
    end
  end
end
