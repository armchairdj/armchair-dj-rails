require 'rails_helper'

RSpec.describe CreatorsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Creator. As you add validations to Creator, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe 'GET #index' do
    it "returns a success response" do
      creator = Creator.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it "returns a success response" do
      creator = Creator.create! valid_attributes
      get :show, params: {id: creator.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context "with valid params" do
      it "creates a new Creator" do
        expect {
          post :create, params: {creator: valid_attributes}, session: valid_session
        }.to change(Creator, :count).by(1)
      end

      it "redirects to the created creator" do
        post :create, params: {creator: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Creator.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {creator: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    it "returns a success response" do
      creator = Creator.create! valid_attributes
      get :edit, params: {id: creator.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested creator" do
        creator = Creator.create! valid_attributes
        put :update, params: {id: creator.to_param, creator: new_attributes}, session: valid_session
        creator.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the creator" do
        creator = Creator.create! valid_attributes
        put :update, params: {id: creator.to_param, creator: valid_attributes}, session: valid_session
        expect(response).to redirect_to(creator)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        creator = Creator.create! valid_attributes
        put :update, params: {id: creator.to_param, creator: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it "destroys the requested creator" do
      creator = Creator.create! valid_attributes
      expect {
        delete :destroy, params: {id: creator.to_param}, session: valid_session
      }.to change(Creator, :count).by(-1)
    end

    it "redirects to the creators list" do
      creator = Creator.create! valid_attributes
      delete :destroy, params: {id: creator.to_param}, session: valid_session
      expect(response).to redirect_to(creators_url)
    end
  end

end
