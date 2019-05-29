# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::ReviewsController do
  it_behaves_like "a_paginatable_controller"

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:review) { create(:minimal_review, :published) }

    it "renders" do
      get :show, params: { slug: review.slug }

      is_expected.to successfully_render("posts/reviews/show")

      expect(assigns(:review)).to eq(review)
    end
  end
end
