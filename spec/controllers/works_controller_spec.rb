require 'rails_helper'

RSpec.describe WorksController, type: :controller do

  let(:valid_attributes) { {
    title: "Work Title",
    creator_id: create(:minimal_creator).id
  } }

  let(:invalid_attributes) { {
    title: "",
    creator_id: nil
  } }

  describe 'GET #index' do
    let(:works) { [
      create(:minimal_work),
      create(:minimal_work)
    ] }

    it "returns a success response" do
      get :index, params: {}

      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:work) {
      create(:minimal_work)
    }

    it "returns a success response" do
      get :show, params: {id: work.to_param}

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
      it "creates a new Work" do
        expect {
          post :create, params: {work: valid_attributes}
        }.to change(Work, :count).by(1)
      end

      it "redirects to the created work" do
        post :create, params: {work: valid_attributes}

        expect(response).to redirect_to(Work.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {work: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'GET #edit' do
    let(:work) {
      create(:minimal_work)
    }

    it "returns a success response" do
      get :edit, params: {id: work.to_param}

      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    let(:work) {
      create(:minimal_work)
    }

    context "with valid params" do
      let(:new_attributes) { {
        title: "New Work Title"
      } }

      it "updates the requested work" do
        put :update, params: {id: work.to_param, work: new_attributes}

        work.reload

        expect(work.title).to eq(new_attributes[:title])
      end

      it "redirects to the work" do
        put :update, params: {id: work.to_param, work: valid_attributes}

        expect(response).to redirect_to(work)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {id: work.to_param, work: invalid_attributes}

        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:work) {
      create(:minimal_work)
    }

    it "destroys the requested work" do
      expect {
        delete :destroy, params: {id: work.to_param}
      }.to change(Work, :count).by(-1)
    end

    it "redirects to the works list" do
      delete :destroy, params: {id: work.to_param}

      expect(response).to redirect_to(works_url)
    end
  end

end
