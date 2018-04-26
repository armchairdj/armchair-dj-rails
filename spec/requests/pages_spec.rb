require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    it "works" do
      get about_path

      expect(response).to have_http_status(200)
    end
  end

  describe "GET /credits" do
    it "works" do
      get credits_path

      expect(response).to have_http_status(200)
    end
  end
end
