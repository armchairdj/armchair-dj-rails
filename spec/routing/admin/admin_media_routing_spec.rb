# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MediaController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/media").to route_to("admin/media#index")
    end

    it "routes to #index pagination" do
      expect(get: "/admin/media/page/2").to route_to("admin/media#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/admin/media/1").to route_to("admin/media#show", id: "1")
    end

    it "routes to #new" do
      expect(get: "/admin/media/new").to route_to("admin/media#new")
    end

    it "routes to #create" do
      expect(post: "/admin/media").to route_to("admin/media#create")
    end

    it "routes to #edit" do
      expect(get: "/admin/media/1/edit").to route_to("admin/media#edit", id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/media/1").to route_to("admin/media#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/media/1").to route_to("admin/media#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/media/1").to route_to("admin/media#destroy", id: "1")
    end

    it "routes to #reorder_facets" do
      expect(post: "/admin/media/1/reorder_facets").to route_to("admin/media#reorder_facets", id: "1")
    end
  end
end
