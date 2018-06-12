# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CreatorsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/creators").to route_to("admin/creators#index")
    end

    it "#index pages" do
      expect(get: "/admin/creators/page/2").to route_to("admin/creators#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/creators/friendly_id").to route_to("admin/creators#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/creators/new").to route_to("admin/creators#new")
    end

    it "#create" do
      expect(post: "/admin/creators").to route_to("admin/creators#create")
    end

    it "#edit" do
      expect(get: "/admin/creators/friendly_id/edit").to route_to("admin/creators#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/creators/friendly_id").to route_to("admin/creators#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/creators/friendly_id").to route_to("admin/creators#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/creators/friendly_id").to route_to("admin/creators#destroy", id: "friendly_id")
    end
  end
end
