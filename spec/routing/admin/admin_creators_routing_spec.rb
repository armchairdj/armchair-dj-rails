require "rails_helper"

RSpec.describe Admin::CreatorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/creators").to route_to("admin/creators#index")
    end

    it "routes to #index pagination" do
      expect(get: "/admin/creators/page/2").to route_to("admin/creators#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/admin/creators/1").to route_to("admin/creators#show", id: "1")
    end

    it "routes to #new" do
      expect(get: "/admin/creators/new").to route_to("admin/creators#new")
    end

    it "routes to #create" do
      expect(post: "/admin/creators").to route_to("admin/creators#create")
    end

    it "routes to #edit" do
      expect(get: "/admin/creators/1/edit").to route_to("admin/creators#edit", id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/creators/1").to route_to("admin/creators#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/creators/1").to route_to("admin/creators#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/creators/1").to route_to("admin/creators#destroy", id: "1")
    end
  end
end
