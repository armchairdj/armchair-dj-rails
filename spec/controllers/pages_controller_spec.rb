require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #about' do
    it "renders" do
      get :about

      expect(response).to be_success
      expect(response).to render_template("pages/about")
    end
  end

  describe 'GET #credits' do
    it "renders" do
      get :credits

      expect(response).to be_success
      expect(response).to render_template("pages/credits")
    end
  end
end
