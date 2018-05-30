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
    context "without records" do
      it "renders" do
        get :index

        is_expected.to successfully_render("creators/index")
        expect(assigns(:creators)).to paginate(0).of_total_records(0)
      end
    end

    context "with records" do
      before(:each) do
        21.times { create(:review, :published) }
      end

      it "renders" do
        get :index

        is_expected.to successfully_render("creators/index")
        expect(assigns(:creators)).to paginate(20).of_total_records(21)
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        is_expected.to successfully_render("creators/index")
        expect(assigns(:creators)).to paginate(1).of_total_records(21)
      end
    end
  end

  describe "GET #show" do
    let(:creator) { create(:minimal_creator, :with_published_post) }

    it "renders" do
        get :show, params: { slug: creator.slug }

        is_expected.to successfully_render("creators/show")

        expect(assigns(:creator)).to eq(creator)
    end
  end
end
