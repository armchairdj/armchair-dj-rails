# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { mixtapes_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:mixtape) { create(:minimal_mixtape, :with_published_post) }

    it "renders" do
        get :show, params: { slug: mixtape.slug }

        is_expected.to successfully_render("mixtapes/show")

        expect(assigns(:mixtape)).to eq(mixtape)
    end
  end
end
