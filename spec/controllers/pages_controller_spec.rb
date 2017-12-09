require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #index' do
    it "returns a success response" do
      get :index

      expect(response).to be_success
      expect(assigns(:homepage)).to eq(true)
    end
  end
end
