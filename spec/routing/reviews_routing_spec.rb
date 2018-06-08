# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/reviews").to route_to("reviews#index")
    end

    it "#index pages" do
      expect(get: "/reviews/page/2").to route_to("reviews#index", page: "2")
    end

    it "#show" do
      expect(get: "/reviews/foo/bar/bat").to route_to("reviews#show", slug: "foo/bar/bat")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/reviews/new").to route_to("reviews#show", slug: "new")
    end

    it "#create" do
      expect(post: "/reviews").to_not be_routable
    end

    it "#edit" do
      expect(get: "/reviews/1/edit").to route_to("reviews#show", slug: "1/edit")
    end

    it "#update via PUT" do
      expect(put: "/reviews/1").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/reviews/1").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/reviews/1").to_not be_routable
    end
  end
end
