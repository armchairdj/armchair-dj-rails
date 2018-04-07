require 'rails_helper'

RSpec.describe WorksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Work. As you add validations to Work, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe 'GET #index' do
    it "returns a success response" do
      work = Work.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it "returns a success response" do
      work = Work.create! valid_attributes
      get :show, params: {id: work.to_param}, session: valid_session
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
      it "creates a new Work" do
        expect {
          post :create, params: {work: valid_attributes}, session: valid_session
        }.to change(Work, :count).by(1)
      end

      it "redirects to the created work" do
        post :create, params: {work: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Work.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {work: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    it "returns a success response" do
      work = Work.create! valid_attributes
      get :edit, params: {id: work.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested work" do
        work = Work.create! valid_attributes
        put :update, params: {id: work.to_param, work: new_attributes}, session: valid_session
        work.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the work" do
        work = Work.create! valid_attributes
        put :update, params: {id: work.to_param, work: valid_attributes}, session: valid_session
        expect(response).to redirect_to(work)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        work = Work.create! valid_attributes
        put :update, params: {id: work.to_param, work: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it "destroys the requested work" do
      work = Work.create! valid_attributes
      expect {
        delete :destroy, params: {id: work.to_param}, session: valid_session
      }.to change(Work, :count).by(-1)
    end

    it "redirects to the works list" do
      work = Work.create! valid_attributes
      delete :destroy, params: {id: work.to_param}, session: valid_session
      expect(response).to redirect_to(works_url)
    end
  end

end
