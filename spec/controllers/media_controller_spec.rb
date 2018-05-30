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
    context "without records" do
      it "renders" do
        get :index

        is_expected.to successfully_render("media/index")
        expect(assigns(:media)).to paginate(0).of_total_records(0)
      end
    end

    context "with records" do
      before(:each) do
        21.times { create(:review, :published) }
      end

      it "renders" do
        get :index

        is_expected.to successfully_render("media/index")
        expect(assigns(:media)).to paginate(20).of_total_records(21)
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        is_expected.to successfully_render("media/index")
        expect(assigns(:media)).to paginate(1).of_total_records(21)
      end
    end
  end

  describe "GET #show" do
    let(:medium) { create(:minimal_medium, :with_published_post) }

    it "renders" do
        get :show, params: { slug: medium.slug }

        is_expected.to successfully_render("media/show")

        expect(assigns(:medium)).to eq(medium)
    end
  end
end
