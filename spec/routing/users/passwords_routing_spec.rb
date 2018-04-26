require "rails_helper"

RSpec.describe Users::PasswordsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/users/password/new").to route_to("users/passwords#new")
    end

    it "routes to #create" do
      expect(post: "/users/password").to route_to("users/passwords#create")
    end

    it "routes to #edit" do
      expect(get: "/users/password/edit").to route_to("users/passwords#edit")
    end

    it "routes to #update via PUT" do
      expect(put: "/users/password").to route_to("users/passwords#update")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/users/password").to route_to("users/passwords#update")
    end
  end
end
