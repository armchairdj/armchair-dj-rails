require "rails_helper"

RSpec.describe ErrorsController, type: :controller do
  describe "GET #permission_denied" do
    it "renders" do
      get :permission_denied

      expect(response).to have_http_status(403)
      expect(response).to render_template("errors/permission_denied")
    end
  end

  describe "GET #not_found" do
    it "renders" do
      get :not_found

      expect(response).to have_http_status(404)
      expect(response).to render_template("errors/not_found")
    end
  end

  describe "GET #bad_request" do
    it "renders" do
      get :bad_request

      expect(response).to have_http_status(422)
      expect(response).to render_template("errors/bad_request")
    end
  end

  describe "GET #internal_server_error" do
    it "renders" do
      get :internal_server_error

      expect(response).to have_http_status(500)
      expect(response).to render_template("errors/internal_server_error")
    end
  end
end
