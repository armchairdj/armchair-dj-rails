# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CreatorsController do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/creators").to route_to("admin/creators#index")
    end

    it "#index pages" do
      expect(get: "/admin/creators/page/2").to route_to("admin/creators#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/creators/1").to route_to("admin/creators#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/creators/new").to route_to("admin/creators#new")
    end

    it "#create" do
      expect(post: "/admin/creators").to route_to("admin/creators#create")
    end

    it "#edit" do
      expect(get: "/admin/creators/1/edit").to route_to("admin/creators#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/creators/1").to route_to("admin/creators#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/creators/1").to route_to("admin/creators#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/creators/1").to route_to("admin/creators#destroy", id: "1")
    end
  end
end
