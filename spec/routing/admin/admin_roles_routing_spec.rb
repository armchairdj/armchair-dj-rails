require "rails_helper"

RSpec.describe Admin::RolesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/roles").to route_to("admin/roles#index")
    end

    it "#new" do
      expect(get: "/admin/roles/new").to route_to("admin/roles#new")
    end

    it "#show" do
      expect(get: "/admin/roles/friendly_id").to route_to("admin/roles#show", id: "friendly_id")
    end

    it "#edit" do
      expect(get: "/admin/roles/friendly_id/edit").to route_to("admin/roles#edit", id: "friendly_id")
    end

    it "#create" do
      expect(post: "/admin/roles").to route_to("admin/roles#create")
    end

    it "#update via PUT" do
      expect(put: "/admin/roles/friendly_id").to route_to("admin/roles#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/roles/friendly_id").to route_to("admin/roles#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/roles/friendly_id").to route_to("admin/roles#destroy", id: "friendly_id")
    end

  end
end
