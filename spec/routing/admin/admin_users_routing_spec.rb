# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UsersController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/users").to route_to("admin/users#index")
    end

    it "#index pages" do
      expect(get: "/admin/users/page/2").to route_to("admin/users#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/users/friendly_id").to route_to("admin/users#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/users/new").to route_to("admin/users#new")
    end

    it "#create" do
      expect(post: "/admin/users").to route_to("admin/users#create")
    end

    it "#edit" do
      expect(get: "/admin/users/friendly_id/edit").to route_to("admin/users#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/users/friendly_id").to route_to("admin/users#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/users/friendly_id").to route_to("admin/users#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/users/friendly_id").to route_to("admin/users#destroy", id: "friendly_id")
    end
  end
end
