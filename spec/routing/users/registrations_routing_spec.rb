# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :routing do
  describe "routes to" do
    it "#new" do
      expect(get: "/register").to route_to("users/registrations#new")
    end

    it "#create" do
      expect(post: "/register").to route_to("users/registrations#create")
    end

    it "#edit" do
      expect(get: "/settings").to route_to("users/registrations#edit")
    end

    it "#update via PUT" do
      expect(put: "/settings").to route_to("users/registrations#update")
    end

    it "#update via PATCH" do
      expect(patch: "/settings").to route_to("users/registrations#update")
    end

    it "#edit_password" do
      expect(get: "/settings/password").to route_to("users/registrations#edit_password")
    end

    it "#update_password via PUT" do
      expect(put: "/settings/password").to route_to("users/registrations#update_password")
    end

    it "#update_password via PATCH" do
      expect(patch: "/settings/password").to route_to("users/registrations#update_password")
    end

    it "#destroy" do
      expect(delete: "/settings").to route_to("users/registrations#destroy")
    end

    it "#profile" do
      expect(get: "/profile/username").to route_to("users/registrations#profile", username: "username")
    end
  end
end
