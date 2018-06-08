# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ArticlesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/articles").to route_to("admin/articles#index")
    end

    it "#index pages" do
      expect(get: "/admin/articles/page/2").to route_to("admin/articles#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/articles/1").to route_to("admin/articles#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/articles/new").to route_to("admin/articles#new")
    end

    it "#create" do
      expect(post: "/admin/articles").to route_to("admin/articles#create")
    end

    it "#edit" do
      expect(get: "/admin/articles/1/edit").to route_to("admin/articles#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/articles/1").to route_to("admin/articles#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/articles/1").to route_to("admin/articles#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/articles/1").to route_to("admin/articles#destroy", id: "1")
    end
  end
end
