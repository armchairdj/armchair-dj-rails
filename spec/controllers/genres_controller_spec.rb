# frozen_string_literal: true

require "rails_helper"

RSpec.describe GenresController, type: :controller do
  context "concerns" do
    it_behaves_like "a_public_controller"

    it_behaves_like "an_seo_paginatable_controller" do
      let(:expected_redirect) { genres_path }
    end
  end

  describe "GET #index" do
    context "without records" do
      it "renders" do
        get :index

        should successfully_render("genres/index")
        expect(assigns(:genres)).to paginate(0).of_total_records(0)
      end
    end

    context "with records" do
      before(:each) do
        21.times { create(:review, :published) }
      end

      it "renders" do
        get :index

        should successfully_render("genres/index")
        expect(assigns(:genres)).to paginate(20).of_total_records(21)
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        should successfully_render("genres/index")
        expect(assigns(:genres)).to paginate(1).of_total_records(21)
      end
    end
  end

  describe "GET #show" do
    let(:genre) { create(:minimal_genre) }

    it "renders" do
        get :show, params: { id: genre.id }

        should successfully_render("genres/show")

        expect(assigns(:genre)).to eq(genre)
    end
  end
end
