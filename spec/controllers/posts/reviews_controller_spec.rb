# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::ReviewsController, type: :controller do
  describe "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:review) { create(:minimal_review, :published) }

    it "renders" do
        get :show, params: { id: review.to_param }

        is_expected.to successfully_render("posts/reviews/show")

        expect(assigns(:review)).to eq(review)
    end
  end
end
