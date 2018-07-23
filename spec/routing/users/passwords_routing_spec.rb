# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::PasswordsController do
  describe "routes to" do
    it "#new" do
      expect(get: "/users/password/new").to route_to("users/passwords#new")
    end

    it "#create" do
      expect(post: "/users/password").to route_to("users/passwords#create")
    end

    it "#edit" do
      expect(get: "/users/password/edit").to route_to("users/passwords#edit")
    end

    it "#update via PUT" do
      expect(put: "/users/password").to route_to("users/passwords#update")
    end

    it "#update via PATCH" do
      expect(patch: "/users/password").to route_to("users/passwords#update")
    end
  end
end
