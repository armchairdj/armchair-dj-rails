# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::WorksController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/works").to route_to("admin/works#index")
    end

    it "#index pages" do
      expect(get: "/admin/works/page/2").to route_to("admin/works#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/works/friendly_id").to route_to("admin/works#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/works/new").to route_to("admin/works#new")
    end

    it "#create" do
      expect(post: "/admin/works").to route_to("admin/works#create")
    end

    it "#edit" do
      expect(get: "/admin/works/friendly_id/edit").to route_to("admin/works#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/works/friendly_id").to route_to("admin/works#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/works/friendly_id").to route_to("admin/works#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/works/friendly_id").to route_to("admin/works#destroy", id: "friendly_id")
    end
  end
end
