# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/categories").to route_to("admin/categories#index")
    end

    it "#index pages" do
      expect(get: "/admin/categories/page/2").to route_to("admin/categories#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/categories/1").to route_to("admin/categories#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/categories/new").to route_to("admin/categories#new")
    end

    it "#create" do
      expect(post: "/admin/categories").to route_to("admin/categories#create")
    end

    it "#edit" do
      expect(get: "/admin/categories/1/edit").to route_to("admin/categories#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/categories/1").to route_to("admin/categories#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/categories/1").to route_to("admin/categories#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/categories/1").to route_to("admin/categories#destroy", id: "1")
    end
  end
end
