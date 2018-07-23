# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::SessionsController do
  describe "routes to" do
    it "#new" do
      expect(get: "/log_in").to route_to("users/sessions#new")
    end

    it "#create" do
      expect(post: "/log_in").to route_to("users/sessions#create")
    end

    it "#destroy" do
      expect(get: "/log_out").to route_to("users/sessions#destroy")
    end
  end
end
