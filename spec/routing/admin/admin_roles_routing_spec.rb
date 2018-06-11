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
      expect(get: "/admin/roles/1").to route_to("admin/roles#show", :id => "1")
    end

    it "#edit" do
      expect(get: "/admin/roles/1/edit").to route_to("admin/roles#edit", :id => "1")
    end

    it "#create" do
      expect(post: "/admin/roles").to route_to("admin/roles#create")
    end

    it "#update via PUT" do
      expect(put: "/admin/roles/1").to route_to("admin/roles#update", :id => "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/roles/1").to route_to("admin/roles#update", :id => "1")
    end

    it "#destroy" do
      expect(delete: "/admin/roles/1").to route_to("admin/roles#destroy", :id => "1")
    end

  end
end
