# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { tags_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:tag) { create(:minimal_tag, :with_published_publication) }

    it "renders" do
        get :show, params: { slug: tag.slug }

        is_expected.to successfully_render("tags/show")

        expect(assigns(:tag)).to eq(tag)
    end
  end
end
