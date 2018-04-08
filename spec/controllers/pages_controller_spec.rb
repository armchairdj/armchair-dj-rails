require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #homepage' do
    it "renders" do
      get :homepage

      expect(response).to be_success
      expect(response).to render_template("pages/homepage")

      expect(assigns(:homepage)).to eq(true)
    end
  end
end
