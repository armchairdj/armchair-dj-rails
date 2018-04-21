require "rails_helper"

RSpec.describe WorksController, type: :controller do
  describe "GET #index" do
    context "without records" do
      it "renders" do
        get :index

        expect(response).to successfully_render("works/index")

        expect(assigns(:works).to paginate(0).of_total(0).records
      end
    end

    context "with records" do
      before(:each) do
        21.times { create(:song_review, :published) }
      end

      it "renders" do
        get :index

        expect(response).to successfully_render("works/index")

        expect(assigns(:works).to paginate(20).of_total(21).records
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        expect(response).to successfully_render("works/index")

        expect(assigns(:works).to paginate(1).of_total(21).records
      end
    end
  end

  describe "GET #show" do
    let(:work) { create(:minimal_work) }

    it "renders" do
        get :show, params: { id: work.id }

        expect(response).to successfully_render("works/show")

        expect(assigns(:work)).to eq(work)
    end
  end

  context "concerns" do
    it_behaves_like "an seo paginatable controller" do
      let(:expected_redirect) { works_path }
    end
  end
end
