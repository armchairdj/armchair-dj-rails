# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/tags").to route_to("tags#index")
    end

    it "#index pages" do
      expect(get: "/tags/page/2").to route_to("tags#index", page: "2")
    end

    it "#show" do
      expect(get: "/tags/foo/bar/bat").to route_to("tags#show", slug: "foo/bar/bat")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/tags/new").to route_to("tags#show", slug: "new")
    end

    it "#create" do
      expect(post: "/tags").to_not be_routable
    end

    it "#edit" do
      expect(get: "/tags/1/edit").to route_to("tags#show", slug: "1/edit")
    end

    it "#update via PUT" do
      expect(put: "/tags/1").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/tags/1").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/tags/1").to_not be_routable
    end
  end
end
