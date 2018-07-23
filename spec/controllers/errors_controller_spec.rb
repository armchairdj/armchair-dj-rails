# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorsController do
  describe "GET #permission_denied" do
    it "renders" do
      get :permission_denied

      is_expected.to render_permission_denied
    end
  end

  describe "GET #not_found" do
    it "renders" do
      get :not_found

      is_expected.to render_not_found
    end
  end

  describe "GET #bad_request" do
    it "renders" do
      get :bad_request

      is_expected.to render_bad_request
    end
  end

  describe "GET #internal_server_error" do
    it "renders" do
      get :internal_server_error

      is_expected.to render_internal_server_error
    end
  end
end
