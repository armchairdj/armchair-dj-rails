# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MixtapesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/mixtapes").to route_to("admin/mixtapes#index")
    end

    it "#index pages" do
      expect(get: "/admin/mixtapes/page/2").to route_to("admin/mixtapes#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/mixtapes/friendly_id").to route_to("admin/mixtapes#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/mixtapes/new").to route_to("admin/mixtapes#new")
    end

    it "#create" do
      expect(post: "/admin/mixtapes").to route_to("admin/mixtapes#create")
    end

    it "#edit" do
      expect(get: "/admin/mixtapes/friendly_id/edit").to route_to("admin/mixtapes#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/mixtapes/friendly_id").to route_to("admin/mixtapes#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/mixtapes/friendly_id").to route_to("admin/mixtapes#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/mixtapes/friendly_id").to route_to("admin/mixtapes#destroy", id: "friendly_id")
    end
  end
end
