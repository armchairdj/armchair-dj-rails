# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/works").to route_to("admin/works#index")
    end

    it "routes to #index pagination" do
      expect(get: "/admin/works/page/2").to route_to("admin/works#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/admin/works/1").to route_to("admin/works#show", id: "1")
    end

    it "routes to #new" do
      expect(get: "/admin/works/new").to route_to("admin/works#new")
    end

    it "routes to #create" do
      expect(post: "/admin/works").to route_to("admin/works#create")
    end

    it "routes to #edit" do
      expect(get: "/admin/works/1/edit").to route_to("admin/works#edit", id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/works/1").to route_to("admin/works#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/works/1").to route_to("admin/works#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/works/1").to route_to("admin/works#destroy", id: "1")
    end
  end
end
