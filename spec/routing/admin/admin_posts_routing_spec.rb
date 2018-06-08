# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PostsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/posts").to route_to("admin/posts#index")
    end

    it "#index pages" do
      expect(get: "/admin/posts/page/2").to route_to("admin/posts#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/posts/1").to route_to("admin/posts#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/posts/new").to route_to("admin/posts#new")
    end

    it "#create" do
      expect(post: "/admin/posts").to route_to("admin/posts#create")
    end

    it "#edit" do
      expect(get: "/admin/posts/1/edit").to route_to("admin/posts#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/posts/1").to route_to("admin/posts#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/posts/1").to route_to("admin/posts#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/posts/1").to route_to("admin/posts#destroy", id: "1")
    end
  end
end
