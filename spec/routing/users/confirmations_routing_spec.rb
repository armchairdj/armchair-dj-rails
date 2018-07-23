# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::ConfirmationsController do
  describe "routes to" do
    it "#new" do
      expect(get: "/users/confirmation/new").to route_to("users/confirmations#new")
    end

    it "#create" do
      expect(post: "/users/confirmation").to route_to("users/confirmations#create")
    end

    it "#show" do
      expect(get: "/users/confirmation").to route_to("users/confirmations#show")
    end
  end
end
