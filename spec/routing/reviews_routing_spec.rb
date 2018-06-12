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
      expect(get: "/reviews/friendly_id").to route_to("reviews#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/reviews/new").to route_to("reviews#show", id: "new")
    end

    it "#create" do
      expect(post: "/reviews").to_not be_routable
    end

    it "#edit" do
      expect(get: "/reviews/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/reviews/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/reviews/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/reviews/friendly_id").to_not be_routable
    end
  end
end
