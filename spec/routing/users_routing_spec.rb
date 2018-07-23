# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController do
  describe "routes to" do
    it "#profile" do
      expect(get: "/profile/username").to route_to("users#show", id: "username")
    end
  end

  describe "does not route to RESTful" do
    it "#index" do
      expect(get: "/users").to_not be_routable
    end

    it "#show" do
      expect(get: "/users/id").to_not be_routable
    end

    it "#new" do
      expect(get: "/users/new").to_not be_routable
    end

    it "#create" do
      expect(post: "/users").to_not be_routable
    end

    it "#edit" do
      expect(get: "/users/id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/users/id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/users/id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/users/id").to_not be_routable
    end
  end
end
