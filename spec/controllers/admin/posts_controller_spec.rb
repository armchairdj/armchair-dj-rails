require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  context 'as admin' do
    login_admin

    describe 'GET #index' do
      pending 'scopes'

      context 'without records' do
        it 'renders' do
          get :index

          expect(response).to be_success
          expect(response).to render_template('admin/posts/index')

          expect(assigns(:posts).total_count).to eq(0)
          expect(assigns(:posts).size       ).to eq(0)
        end
      end

      context 'with records' do
        before(:each) do
          ( per_page / 2     ).times { create(:song_review    ) }
          ((per_page / 2) + 1).times { create(:standalone_post) }
        end

        it 'renders' do
          get :index

          expect(response).to be_success
          expect(response).to render_template('admin/posts/index')

          expect(assigns(:posts).total_count).to eq(per_page + 1)
          expect(assigns(:posts).size       ).to eq(per_page)
        end

        it 'renders second page' do
          get :index, params: { page: 2 }

          expect(response).to be_success
          expect(response).to render_template('admin/posts/index')

          expect(assigns(:posts).total_count).to eq(per_page + 1)
          expect(assigns(:posts).size       ).to eq(1)
        end
      end
    end

    describe 'GET #show' do
      context 'standalone' do
        let(:post) { create(:standalone_post) }

        it 'renders' do
          get :show, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template('admin/posts/show')

          expect(assigns(:post)).to eq(post)
        end
      end

      context 'review' do
        let(:post) { create(:song_review) }

        it 'renders' do
          get :show, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template('admin/posts/show')

          expect(assigns(:post)).to eq(post)
        end
      end
    end

    describe 'GET #new' do
      it 'renders' do
        get :new

        expect(response).to be_success
        expect(response).to render_template('admin/posts/new')

        expect(assigns(:post)                          ).to be_a_new(Post)
        expect(assigns(:post).work                     ).to be_a_new(Work)
        expect(assigns(:post).work.contributions.length).to eq(10)

        expect(assigns(:works)).to be_a_kind_of(Array)

        expect(assigns(:allow_new_work)).to eq(true)
        expect(assigns(:roles         )).to be_a_kind_of(Array)
        expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)

        expect(assigns(:selected_tab)).to eq('post-choose-work')
      end
    end

    describe 'POST #create' do
      context 'standalone' do
        let(  :valid_params) { { 'title' => 'title', 'body' => 'body' } }
        let(:invalid_params) { valid_params.except('title') }

        pending 'incomplete'

        context 'with valid params' do
          it 'creates a new Post' do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it 'redirects to post' do
            post :create, params: { post: valid_params }

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context 'with invalid params' do
          it 'renders new' do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template('admin/posts/new')

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns(:works)).to be_a_kind_of(Array)

            expect(assigns(:allow_new_work)).to eq(true)
            expect(assigns(:roles         )).to be_a_kind_of(Array)
            expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)

            expect(assigns(:selected_tab)).to eq('post-choose-work')
          end
        end
      end

      context 'existing work' do
        let(  :valid_params) { { 'body' => 'body', 'work_id' => create(:song).id } }
        let(:invalid_params) { valid_params.except('work_id') }

        pending 'incomplete'

        context 'with valid params' do
          it 'creates a new Post' do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it 'redirects to post' do
            post :create, params: { post: valid_params }

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context 'with invalid params' do
          it 'renders new' do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template('admin/posts/new')

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns(:works)).to be_a_kind_of(Array)

            expect(assigns(:allow_new_work)).to eq(true)
            expect(assigns(:roles         )).to be_a_kind_of(Array)
            expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)

            expect(assigns(:selected_tab)).to eq('post-choose-work')
          end
        end
      end

      context 'new work' do
        let(:valid_params) { {
          'body'            => 'body',
          'work_attributes' => {
            'medium'                   => 'song',
            'title'                    => 'Hounds of Love',
            'contributions_attributes' => {
              '0' => {
                'role'       => 'creator',
                'creator_id' => create(:musician).id
              }
            }
          }
        } }

        let(:invalid_params) { valid_params.except('work_attributes') }

        pending 'incomplete'

        context 'with valid params' do
          it 'creates a new Post' do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Post, :count).by(1)
          end

          it 'creates a new Work' do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Work, :count).by(1)
          end

          it 'creates a new Contribution' do
            expect {
              post :create, params: { post: valid_params }
            }.to change(Contribution, :count).by(1)
          end

          it 'redirects to post' do
            post :create, params: { post: valid_params }

            expect(response).to redirect_to(admin_post_path(assigns[:post]))
          end
        end

        context 'with invalid params' do
          it 'renders new' do
            post :create, params: { post: invalid_params }

            expect(response).to be_success
            expect(response).to render_template('admin/posts/new')

            expect(assigns(:post)       ).to be_a_new(Post)
            expect(assigns(:post).valid?).to eq(false)

            expect(assigns(:works)).to be_a_kind_of(Array)

            expect(assigns(:allow_new_work)).to eq(true)
            expect(assigns(:roles         )).to be_a_kind_of(Array)
            expect(assigns(:creators      )).to be_a_kind_of(ActiveRecord::Relation)

            expect(assigns(:selected_tab)).to eq('post-choose-work')
          end
        end
      end
    end

    describe 'GET #edit' do
      context 'standalone' do
        let(:post) { create(:minimal_post) }

        it 'renders' do
          get :edit, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template('admin/posts/edit')

          expect(assigns(:post)).to eq(post)

          expect(assigns(:works)).to be_a_kind_of(Array)

          expect(assigns(:allow_new_work)).to eq(false)
          expect(assigns(:roles         )).to eq(nil)
          expect(assigns(:creators      )).to eq(nil)

          expect(assigns(:selected_tab)).to eq('post-standalone')
        end
      end

      context 'review' do
        let(:post) { create(:song_review) }

        it 'renders' do
          get :edit, params: { id: post.to_param }

          expect(response).to be_success
          expect(response).to render_template('admin/posts/edit')

          expect(assigns(:post)).to eq(post)

          expect(assigns(:works   )).to be_a_kind_of(Array)

          expect(assigns(:allow_new_work)).to eq(false)
          expect(assigns(:roles         )).to eq(nil)
          expect(assigns(:creators      )).to eq(nil)

          expect(assigns(:selected_tab)).to eq('post-choose-work')
        end
      end
    end

    describe 'PUT #update' do
      context 'draft' do
        context 'standalone' do
          let(:post) { create(:standalone_post) }

          let(  :valid_params) { { 'title' => 'New Title' } }
          let(:invalid_params) { { 'title' => ''          } }

          context 'with valid params' do
            it 'updates the requested post' do
              put :update, params: { id: post.to_param, post: valid_params }

              post.reload

              expect(post.title).to eq(valid_params['title'])
            end

            it 'redirects to post' do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end
          end

          context 'with invalid params' do
            it 'renders edit' do
              put :update, params: { id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template('admin/posts/edit')

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns(:works)).to be_a_kind_of(Array)

              expect(assigns(:allow_new_work)).to eq(false)
              expect(assigns(:roles         )).to eq(nil)
              expect(assigns(:creators      )).to eq(nil)

              expect(assigns(:selected_tab)).to eq('post-choose-work')
            end
          end
        end

        context 'review' do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { 'work_id' => create(:song).id } }
          let(:invalid_params) { { 'work_id' => ''               } }

          context 'with valid params' do
            it 'updates the requested post' do
              put :update, params: { id: post.to_param, post: valid_params }

              post.reload

              expect(post.work_id).to eq(valid_params['work_id'])
            end

            it 'redirects to post' do
              put :update, params: { id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end
          end

          context 'with invalid params' do
            it 'renders edit' do
              put :update, params: { id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template('admin/posts/edit')

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns(:works)).to be_a_kind_of(Array)

              expect(assigns(:allow_new_work)).to eq(false)
              expect(assigns(:roles         )).to eq(nil)
              expect(assigns(:creators      )).to eq(nil)

              expect(assigns(:selected_tab)).to eq('post-choose-work')
            end
          end
        end
      end

      context 'publish' do
        context 'standalone' do
          let(:post) { create(:standalone_post) }

          let(  :valid_params) { { 'body' => 'New body.' } }
          let(:invalid_params) { { 'body' => ''          } }

          context 'with valid params' do
            it 'updates the requested post' do
              put :update, params: { step: 'publish', id: post.to_param, post: valid_params }

              post.reload

              expect(post.body        ).to eq(valid_params['body'])
              expect(post.published?  ).to eq(true)
              expect(post.slug.blank? ).to eq(false)
              expect(post.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            end

            it 'redirects to post' do
              put :update, params: { step: 'publish', id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end

            pending 'flash'
          end

          context 'with invalid params' do
            it 'renders edit' do
              put :update, params: { step: 'publish', id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template('admin/posts/edit')

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns(:works)).to be_a_kind_of(Array)

              expect(assigns(:allow_new_work)).to eq(false)
              expect(assigns(:roles         )).to eq(nil)
              expect(assigns(:creators      )).to eq(nil)

              expect(assigns(:selected_tab)).to eq('post-standalone')

              expect(post.published_at).to eq(nil)
              expect(post.published?  ).to eq(false)
              expect(post.slug.blank? ).to eq(true)
            end
          end

          context 'with failed transition' do
            pending 'renders edit with message'
          end
        end

        context 'review' do
          let(:post) { create(:song_review) }

          let(  :valid_params) { { 'body' => 'New body.' } }
          let(:invalid_params) { { 'body' => ''          } }

          context 'with valid params' do
            it 'updates the requested post' do
              put :update, params: { step: 'publish', id: post.to_param, post: valid_params }

              post.reload

              expect(post.body        ).to eq(valid_params['body'])
              expect(post.published?  ).to eq(true)
              expect(post.slug.blank? ).to eq(false)
              expect(post.published_at).to be_a_kind_of(ActiveSupport::TimeWithZone)
            end

            it 'redirects to post' do
              put :update, params: { step: 'publish', id: post.to_param, post: valid_params }

              expect(response).to redirect_to(admin_post_path(post))
            end

            pending 'flash'
          end

          context 'with invalid params' do
            it 'renders edit' do
              put :update, params: { step: 'publish', id: post.to_param, post: invalid_params }

              expect(response).to be_success
              expect(response).to render_template('admin/posts/edit')

              expect(assigns(:post)       ).to eq(post)
              expect(assigns(:post).valid?).to eq(false)

              expect(assigns(:works)).to be_a_kind_of(Array)

              expect(assigns(:allow_new_work)).to eq(false)
              expect(assigns(:roles         )).to eq(nil)
              expect(assigns(:creators      )).to eq(nil)

              expect(assigns(:selected_tab)).to eq('post-choose-work')

              expect(post.published_at).to eq(nil)
              expect(post.published?  ).to eq(false)
              expect(post.slug.blank? ).to eq(true)
            end
          end

          context 'with failed transition' do
            pending 'renders edit with message'
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:post) { create(:minimal_post) }

      it 'destroys the requested post' do
        expect {
          delete :destroy, params: { id: post.to_param }
        }.to change(Post, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: post.to_param }

        expect(response).to redirect_to(admin_posts_path)
      end
    end
  end

  context 'concerns' do
    it_behaves_like 'an admin controller' do
      let(:expected_redirect_for_seo_paginatable) { admin_posts_path }
      let(:instance                             ) { create(:minimal_post) }
    end
  end
end
