# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErrorsController, type: :routing do
  describe "routes to" do
    it "#bad_request" do
      expect(get: "/422").to route_to("errors#bad_request")
    end

    it "#internal_server_error" do
      expect(get: "/500").to route_to("errors#internal_server_error")
    end

    it "#not_found" do
      expect(get: "/404").to route_to("errors#not_found")
    end

    it "#permission_denied" do
      expect(get: "/403").to route_to("errors#permission_denied")
    end
  end
end
