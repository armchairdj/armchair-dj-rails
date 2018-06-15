# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/tags").to route_to("admin/tags#index")
    end

    it "#index pages" do
      expect(get: "/admin/tags/page/2").to route_to("admin/tags#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/tags/friendly_id").to route_to("admin/tags#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/tags/new").to route_to("admin/tags#new")
    end

    it "#create" do
      expect(post: "/admin/tags").to route_to("admin/tags#create")
    end

    it "#edit" do
      expect(get: "/admin/tags/friendly_id/edit").to route_to("admin/tags#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/tags/friendly_id").to route_to("admin/tags#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/tags/friendly_id").to route_to("admin/tags#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/tags/friendly_id").to route_to("admin/tags#destroy", id: "friendly_id")
    end
  end
end
