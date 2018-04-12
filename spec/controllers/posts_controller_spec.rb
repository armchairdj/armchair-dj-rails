require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  describe 'GET #index' do
    context 'without records' do
      it 'renders' do
        get :index

        expect(response).to be_success
        expect(response).to render_template('posts/index')

        expect(assigns(:posts).total_count).to eq(0)
        expect(assigns(:posts).size       ).to eq(0)
      end
    end

    context 'with unpublished records' do
      before(:each) do
        ( per_page / 2     ).times { create(:song_review    ) }
        ((per_page / 2) + 1).times { create(:standalone_post) }
      end

      it 'renders' do
        get :index

        expect(response).to be_success
        expect(response).to render_template('posts/index')

        expect(assigns(:posts).total_count).to eq(0)
        expect(assigns(:posts).size       ).to eq(0)
      end
    end

    context 'with published records' do
      before(:each) do
        ( per_page / 2     ).times { create(:song_review,     :published) }
        ((per_page / 2) + 1).times { create(:standalone_post, :published) }
      end

      it 'renders' do
        get :index

        expect(response).to be_success
        expect(response).to render_template('posts/index')

        expect(assigns(:posts).total_count).to eq(per_page + 1)
        expect(assigns(:posts).size       ).to eq(per_page)
      end

      it 'renders second page' do
        get :index, params: { page: 2 }

        expect(response).to be_success
        expect(response).to render_template('posts/index')

        expect(assigns(:posts).total_count).to eq(per_page + 1)
        expect(assigns(:posts).size       ).to eq(1)
      end
    end
  end

  describe 'GET #show' do
    let(:post) { create(:minimal_post, slug: "slug/path") }

    it 'renders' do
        get :show, params: { slug: post.slug }

        expect(response).to be_success
        expect(response).to render_template('posts/show')

        expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET #feed' do
    pending 'renders rss'
  end

  context 'concerns' do
    it_behaves_like 'an seo paginatable controller' do
      let(:expected_redirect) { posts_path }
    end
  end
end
