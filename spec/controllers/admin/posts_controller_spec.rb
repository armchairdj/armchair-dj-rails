require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do

  let(:valid_attributes) { {
    title: "Post Title",
    body: "Post Content",
  } }

  let(:invalid_attributes) { {
    title: "",
    body: ""
  } }

  describe 'GET #index' do
    let(:posts) { [
      create(:minimal_post),
      create(:minimal_post)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:post) {
      create(:minimal_post)
    }

    it "returns a success response" do
      get :show, params: {id: post.to_param}

      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it "returns a success response" do
      get :new, params: {}

      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context "with valid params" do
      it "creates a new Post" do
        expect {
          post :create, params: {post: valid_attributes}
        }.to change(Post, :count).by(1)
      end

      it "redirects to the created post" do
        post :create, params: {post: valid_attributes}

        expect(response).to redirect_to(Post.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {post: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    let(:post) {
      create(:minimal_post)
    }

    it "returns a success response" do
      get :edit, params: {id: post.to_param}

      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    let(:post) {
      create(:minimal_post)
    }

    context "with valid params" do
      let(:new_attributes) { {
        title: "Updated title"
      } }

      it "updates the requested post" do
        put :update, params: {id: post.to_param, post: new_attributes}

        post.reload

        expect(post.title).to eq(new_attributes[:title])
      end

      it "redirects to the post" do
        put :update, params: {id: post.to_param, post: valid_attributes}

        expect(response).to redirect_to(post)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: post.to_param, post: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:post) {
      create(:minimal_post)
    }

    it "destroys the requested post" do
      expect {
        delete :destroy, params: {id: post.to_param}
      }.to change(Post, :count).by(-1)
    end

    it "redirects to the posts list" do
      delete :destroy, params: {id: post.to_param}

      expect(response).to redirect_to(posts_url)
    end
  end

end
