# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::UnlocksController do
  describe "routes to" do
    it "#new" do
      expect(get: "/users/unlock/new").to route_to("users/unlocks#new")
    end

    it "#create" do
      expect(post: "/users/unlock").to route_to("users/unlocks#create")
    end

    it "#show" do
      expect(get: "/users/unlock").to route_to("users/unlocks#show")
    end
  end
end
