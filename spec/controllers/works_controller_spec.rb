# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { works_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:work) { create(:minimal_song, :with_published_post) }

    it "renders" do
        get :show, params: { slug: work.slug }

        is_expected.to successfully_render("works/show")

        expect(assigns(:work)).to eq(work)
    end
  end
end
