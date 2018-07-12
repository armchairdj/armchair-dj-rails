# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ReviewsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/reviews").to route_to("admin/posts/reviews#index")
    end

    it "#index pages" do
      expect(get: "/admin/reviews/page/2").to route_to("admin/posts/reviews#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/reviews/1").to route_to("admin/posts/reviews#show", id: "1")
    end

    it "#new" do
      expect(get: "/admin/reviews/new").to route_to("admin/posts/reviews#new")
    end

    it "#create" do
      expect(post: "/admin/reviews").to route_to("admin/posts/reviews#create")
    end

    it "#edit" do
      expect(get: "/admin/reviews/1/edit").to route_to("admin/posts/reviews#edit", id: "1")
    end

    it "#update via PUT" do
      expect(put: "/admin/reviews/1").to route_to("admin/posts/reviews#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/reviews/1").to route_to("admin/posts/reviews#update", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/reviews/1").to route_to("admin/posts/reviews#destroy", id: "1")
    end
  end
end
