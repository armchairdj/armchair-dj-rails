# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::MixtapesController do
  it_behaves_like "a_paginatable_controller"

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #show" do
    let(:mixtape) { create(:minimal_mixtape, :published) }

    it "renders" do
      get :show, params: { slug: mixtape.slug }

      is_expected.to successfully_render("posts/mixtapes/show")

      expect(assigns(:mixtape)).to eq(mixtape)
    end
  end
end
