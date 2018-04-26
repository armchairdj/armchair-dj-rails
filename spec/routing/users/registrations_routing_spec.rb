require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/register").to route_to("users/registrations#new")
    end

    it "routes to #create" do
      expect(post: "/register").to route_to("users/registrations#create")
    end

    it "routes to #edit" do
      expect(get: "/settings").to route_to("users/registrations#edit")
    end

    it "routes to #update via PUT" do
      expect(put: "/settings").to route_to("users/registrations#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/settings").to route_to("users/registrations#update")
    end

    it "routes to #edit_password" do
      expect(get: "/settings/password").to route_to("users/registrations#edit_password")
    end

    it "routes to #update_password via PUT" do
      expect(put: "/settings/password").to route_to("users/registrations#update_password")
    end

    it "routes to #update_password via PATCH" do
      expect(patch: "/settings/password").to route_to("users/registrations#update_password")
    end

    it "routes to #destroy" do
      expect(delete: "/settings").to route_to("users/registrations#destroy")
    end

    it "routes to #profile" do
      expect(get: "/profile/username").to route_to("users/registrations#profile", username: "username")
    end
  end
end
