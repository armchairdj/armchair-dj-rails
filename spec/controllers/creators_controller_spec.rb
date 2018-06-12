# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorsController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { creators_path }
    end
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:creator) { create(:minimal_creator, :with_published_post) }

    it "renders" do
        get :show, params: { id: creator.to_param }

        is_expected.to successfully_render("creators/show")

        expect(assigns(:creator)).to eq(creator)
    end
  end
end
