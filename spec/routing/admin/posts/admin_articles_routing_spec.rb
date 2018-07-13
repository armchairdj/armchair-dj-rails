# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ArticlesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/articles").to route_to("admin/posts/articles#index")
    end

    it "#index pages" do
      expect(get: "/admin/articles/page/2").to route_to("admin/posts/articles#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/articles/1").to route_to("admin/posts/articles#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/articles/new").to route_to("admin/posts/articles#new")
    end

    it "#create" do
      expect(post: "/admin/articles").to route_to("admin/posts/articles#create")
    end

    it "#edit" do
      expect(get: "/admin/articles/1/edit").to route_to("admin/posts/articles#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/articles/1").to route_to("admin/posts/articles#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/articles/1").to route_to("admin/posts/articles#update", id: "1")
    end

    it "#autosave via PUT" do
      expect(put: "/admin/articles/1/autosave").to route_to("admin/posts/articles#autosave", id: "1")
    end

    it "#autosave via PATCH" do
      expect(patch: "/admin/articles/1/autosave").to route_to("admin/posts/articles#autosave", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/articles/1").to route_to("admin/posts/articles#destroy", id: "1")
    end
  end
end
