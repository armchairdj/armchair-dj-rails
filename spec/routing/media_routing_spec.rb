# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/media").to route_to("media#index")
    end

    it "#index pages" do
      expect(get: "/media/page/2").to route_to("media#index", page: "2")
    end

    it "#show" do
      expect(get: "/media/foo/bar/bat").to route_to("media#show", slug: "foo/bar/bat")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/media/new").to route_to("media#show", slug: "new")
    end

    it "#create" do
      expect(post: "/media").to_not be_routable
    end

    it "#edit" do
      expect(get: "/media/1/edit").to route_to("media#show", slug: "1/edit")
    end

    it "#update via PUT" do
      expect(put: "/media/1").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/media/1").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/media/1").to_not be_routable
    end
  end
end
