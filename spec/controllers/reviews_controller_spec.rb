require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do

  let(:valid_attributes) { {
    title: "Review Title",
    content: "content",
    reviewable_gid: create(:minimal_song).to_global_id
  } }

  let(:invalid_attributes) { {
    title: "",
    content: "",
    reviewable_gid: nil
  } }

  describe "GET #index" do
    let(:reviews) { [
      create(:minimal_review),
      create(:minimal_review)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success
    end
  end

  describe "GET #show" do
    let(:review) {
      create(:minimal_review)
    }

    it "returns a success response" do
      get :show, params: {id: review.to_param}

      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}

      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Review" do
        expect {
          post :create, params: {review: valid_attributes}
        }.to change(Review, :count).by(1)
      end

      it "redirects to the created review" do
        post :create, params: {review: valid_attributes}

        expect(response).to redirect_to(Review.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {review: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    let(:review) {
      create(:minimal_review)
    }

    it "returns a success response" do
      get :edit, params: {id: review.to_param}

      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    let(:review) {
      create(:minimal_review)
    }

    context "with valid params" do
      let(:new_attributes) { {
        title: "Updated title"
      } }

      it "updates the requested review" do
        put :update, params: {id: review.to_param, review: new_attributes}

        review.reload

        expect(review.title).to eq(new_attributes[:title])
      end

      it "redirects to the review" do
        put :update, params: {id: review.to_param, review: valid_attributes}

        expect(response).to redirect_to(review)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: review.to_param, review: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:review) {
      create(:minimal_review)
    }

    it "destroys the requested review" do
      expect {
        delete :destroy, params: {id: review.to_param}
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviews list" do
      delete :destroy, params: {id: review.to_param}

      expect(response).to redirect_to(reviews_url)
    end
  end

end
