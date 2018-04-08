require 'rails_helper'

RSpec.describe CreatorsController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  describe 'GET #index' do
    context "without records" do
      it "renders" do
        get :index

        expect(response).to be_success
        expect(response).to render_template("creators/index")

        expect(assigns(:creators).total_count).to eq(0)
        expect(assigns(:creators).size       ).to eq(0)
      end
    end

    context "with records" do
      before(:each) do
        (per_page + 1).times { create(:song_review) }
      end

      it "renders" do
        get :index

        expect(response).to be_success
        expect(response).to render_template("creators/index")

        expect(assigns(:creators).total_count).to eq(per_page + 1)
        expect(assigns(:creators).size       ).to eq(per_page)
      end

      it "renders second page" do
        get :index, params: { page: 2 }

        expect(response).to be_success
        expect(response).to render_template("creators/index")

        expect(assigns(:creators).total_count).to eq(per_page + 1)
        expect(assigns(:creators).size       ).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let(:creator) { create(:minimal_creator) }

    it "renders" do
        get :show, params: { id: creator.id }

        expect(response).to be_success
        expect(response).to render_template("creators/show")

        expect(assigns(:creator)).to eq(creator)
    end
  end
end
