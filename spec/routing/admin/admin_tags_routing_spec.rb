# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagsController do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/tags").to route_to("admin/tags#index")
    end

    it "#index pages" do
      expect(get: "/admin/tags/page/2").to route_to("admin/tags#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/tags/1").to route_to("admin/tags#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/tags/new").to route_to("admin/tags#new")
    end

    it "#create" do
      expect(post: "/admin/tags").to route_to("admin/tags#create")
    end

    it "#edit" do
      expect(get: "/admin/tags/1/edit").to route_to("admin/tags#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/tags/1").to route_to("admin/tags#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/tags/1").to route_to("admin/tags#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/tags/1").to route_to("admin/tags#destroy", id: "1")
    end
  end
end
