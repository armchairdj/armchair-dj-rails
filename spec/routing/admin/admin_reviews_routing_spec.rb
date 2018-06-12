# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ReviewsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/reviews").to route_to("admin/reviews#index")
    end

    it "#index pages" do
      expect(get: "/admin/reviews/page/2").to route_to("admin/reviews#index", page: "2")
    end

    it "#show" do
      expect(get: "/admin/reviews/friendly_id").to route_to("admin/reviews#show", id: "friendly_id")
    end

    it "#new" do
      expect(get: "/admin/reviews/new").to route_to("admin/reviews#new")
    end

    it "#create" do
      expect(post: "/admin/reviews").to route_to("admin/reviews#create")
    end

    it "#edit" do
      expect(get: "/admin/reviews/friendly_id/edit").to route_to("admin/reviews#edit", id: "friendly_id")
    end

    it "#update via PUT" do
      expect(put: "/admin/reviews/friendly_id").to route_to("admin/reviews#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/reviews/friendly_id").to route_to("admin/reviews#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/reviews/friendly_id").to route_to("admin/reviews#destroy", id: "friendly_id")
    end
  end
end
