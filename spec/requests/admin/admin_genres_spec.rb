require 'rails_helper'

RSpec.describe "Admin::Genres", type: :request do
  describe "GET /admin_genres" do
    it "works! (now write some real specs)" do
      get admin_genres_path
      expect(response).to have_http_status(200)
    end
  end
end
