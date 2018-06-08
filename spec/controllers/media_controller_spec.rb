# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { media_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:medium) { create(:minimal_medium, :with_published_publication) }

    it "renders" do
        get :show, params: { slug: medium.slug }

        is_expected.to successfully_render("media/show")

        expect(assigns(:medium)).to eq(medium)
    end
  end
end
