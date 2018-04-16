require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /about" do
    it "works" do
      get about_path

      expect(response).to be_success
    end
  end

  describe "GET /credits" do
    it "works" do
      get credits_path

      expect(response).to be_success
    end
  end
end
