require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let(:per_page) { Kaminari.config.default_per_page }

  context "as admin" do
    login_admin

    describe 'GET #index' do
      pending "scopes"

      context "without records" do
        it "renders" do
          get :index

          expect(response).to be_success
          expect(response).to render_template("admin/posts/index")

          expect(assigns(:posts).total_count).to eq(0)
          expect(assigns(:posts).size       ).to eq(0)
        end
      end

      context "with records" do
        before(:each) do
          ( per_page / 2     ).times { create(:review_post) }
          ((per_page / 2) + 1).times { create(:standalone_post) }
        end

        it "renders" do
          get :index

          expect(response).to be_success
          expect(response).to render_template("admin/posts/index")

          expect(assigns(:posts).total_count).to eq(per_page + 1)
          expect(assigns(:posts).size       ).to eq(per_page)
        end

        it "renders second page" do
          get :index, params: { page: 2 }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/index")

          expect(assigns(:posts).total_count).to eq(per_page + 1)
          expect(assigns(:posts).size       ).to eq(1)
        end
      end
    end

    describe 'GET #show' do
      let(:post) { create(:minimal_post) }

      it "renders" do
        get :show, params: { id: post.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/posts/show")

        expect(assigns(:post)).to eq(post)
      end
    end

    describe 'GET #new' do
      it "returns a success response" do
        get :new

        expect(response).to be_success
        expect(response).to render_template("admin/posts/new")

        expect(assigns(:post)).to be_a_new(Post)
      end
    end

    describe 'POST #create' do
      let(  :valid_attributes) { attributes_for(:minimal_post) }
      let(:invalid_attributes) { attributes_for(:minimal_post).except(:title) }

      context "with valid params" do
        it "creates a new Post" do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it "redirects to index" do
          post :create, params: { post: valid_attributes }

          expect(response).to redirect_to(admin_posts_path)
        end
      end

      context "with invalid params" do
        it "renders new" do
          post :create, params: { post: invalid_attributes }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/new")

          expect(assigns(:post)       ).to be_a_new(Post)
          expect(assigns(:post).valid?).to eq(false)
        end
      end
    end

    describe 'GET #edit' do
      let(:post) { create(:minimal_post) }

      it "returns a success response" do
        get :edit, params: { id: post.to_param }

        expect(response).to be_success
        expect(response).to render_template("admin/posts/edit")

        expect(assigns(:post)).to eq(post)
      end
    end

    describe 'PUT #update' do
      let(:post) { create(:minimal_post) }

      let(  :valid_attributes) { { title: "New Title" } }
      let(:invalid_attributes) { { title: ""          } }

      context "with valid params" do
        it "updates the requested post" do
          put :update, params: { id: post.to_param, post: valid_attributes }

          post.reload

          expect(post.title).to eq(valid_attributes[:title])
        end

        it "redirects to index" do
          put :update, params: { id: post.to_param, post: valid_attributes }

          expect(response).to redirect_to(admin_posts_path)
        end
      end

      context "with invalid params" do
        it "renders edit" do
          put :update, params: { id: post.to_param, post: invalid_attributes }

          expect(response).to be_success
          expect(response).to render_template("admin/posts/edit")

          expect(assigns(:post)       ).to eq(post)
          expect(assigns(:post).valid?).to eq(false)
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:post) { create(:minimal_post) }

      it "destroys the requested post" do
        expect {
          delete :destroy, params: { id: post.to_param }
        }.to change(Post, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, params: { id: post.to_param }

        expect(response).to redirect_to(admin_posts_path)
      end
    end
  end
end
