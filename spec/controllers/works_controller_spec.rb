require "rails_helper"

RSpec.describe WorksController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  describe 'GET #index' do
    context 'without records' do
      it 'renders' do
        get :index

        expect(response).to be_success
        expect(response).to render_template('works/index')

        expect(assigns(:works).total_count).to eq(0)
        expect(assigns(:works).size       ).to eq(0)
      end
    end

    context 'with records' do
      before(:each) do
        (per_page + 1).times { create(:song_review) }
      end

      it 'renders' do
        get :index

        expect(response).to be_success
        expect(response).to render_template('works/index')

        expect(assigns(:works).total_count).to eq(per_page + 1)
        expect(assigns(:works).size       ).to eq(per_page)
      end

      it 'renders second page' do
        get :index, params: { page: 2 }

        expect(response).to be_success
        expect(response).to render_template('works/index')

        expect(assigns(:works).total_count).to eq(per_page + 1)
        expect(assigns(:works).size       ).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let(:work) { create(:minimal_work) }

    it 'renders' do
        get :show, params: { id: work.id }

        expect(response).to be_success
        expect(response).to render_template('works/show')

        expect(assigns(:work)).to eq(work)
    end
  end

  context 'concerns' do
    it_behaves_like 'an seo paginatable controller' do
      let(:expected_redirect) { works_path }
    end
  end
end
