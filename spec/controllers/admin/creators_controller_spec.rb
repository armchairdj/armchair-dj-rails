require 'rails_helper'

RSpec.describe Admin::CreatorsController, type: :controller do

  let(:valid_attributes) { {
    name: "Kate Bush"
  } }

  let(:invalid_attributes) { {
    name: ""
  } }

  describe 'GET #index' do
    let(:creators) { [
      create(:minimal_creator),
      create(:minimal_creator)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success

      expect(assigns(:creators)).to match_array(creators)
    end
  end

  describe 'GET #show' do
    let(:creator) {
      create(:minimal_creator)
    }

    it "returns a success response" do
      get :show, params: {id: creator.to_param}

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
      it "creates a new Creator" do
        expect {
          post :create, params: {creator: valid_attributes}
        }.to change(Creator, :count).by(1)
      end

      it "redirects to the created creator" do
        post :create, params: {creator: valid_attributes}

        expect(response).to redirect_to(Creator.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {creator: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    let(:creator) {
      create(:minimal_creator)
    }

    it "returns a success response" do
      get :edit, params: {id: creator.to_param}

      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    let(:creator) {
      create(:minimal_creator)
    }

    context "with valid params" do
      let(:new_attributes) { {
        name: "Updated name"
      } }

      it "updates the requested creator" do
        put :update, params: { id: creator.to_param, creator: new_attributes}

        creator.reload

        expect(creator.name).to eq(new_attributes[:name])
      end

      it "redirects to the creator" do
        put :update, params: {id: creator.to_param, creator: valid_attributes}

        expect(response).to redirect_to(creator)
      end
    end

    context "with invalid params" do
      it "returns a success response" do
        put :update, params: {id: creator.to_param, creator: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:creator) {
      create(:minimal_creator)
    }

    it "destroys the requested creator" do
      expect {
        delete :destroy, params: {id: creator.to_param}
      }.to change(Creator, :count).by(-1)
    end

    it "redirects to the creators list" do
      delete :destroy, params: {id: creator.to_param}

      expect(response).to redirect_to(creators_url)
    end
  end
end
