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
      expect(get: "/admin/mixtapes/1").to route_to("admin/mixtapes#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/mixtapes/new").to route_to("admin/mixtapes#new")
    end

    it "#create" do
      expect(post: "/admin/mixtapes").to route_to("admin/mixtapes#create")
    end

    it "#edit" do
      expect(get: "/admin/mixtapes/1/edit").to route_to("admin/mixtapes#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/mixtapes/1").to route_to("admin/mixtapes#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/mixtapes/1").to route_to("admin/mixtapes#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/mixtapes/1").to route_to("admin/mixtapes#destroy", id: "1")
    end
  end
end
