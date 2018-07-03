# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::MixtapesController, type: :controller do
  context "concerns" do
    it_behaves_like "a_paginatable_controller"
  end

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:mixtape) { create(:minimal_mixtape, :published) }

    it "renders" do
        get :show, params: { id: mixtape.to_param }

        is_expected.to successfully_render("posts/mixtapes/show")

        expect(assigns(:mixtape)).to eq(mixtape)
    end
  end
end
