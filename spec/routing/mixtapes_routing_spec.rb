# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/mixtapes").to route_to("mixtapes#index")
    end

    it "#index pages" do
      expect(get: "/mixtapes/page/2").to route_to("mixtapes#index", page: "2")
    end

    it "#show" do
      expect(get: "/mixtapes/foo/bar/bat").to route_to("mixtapes#show", slug: "foo/bar/bat")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/mixtapes/new").to route_to("mixtapes#show", slug: "new")
    end

    it "#create" do
      expect(post: "/mixtapes").to_not be_routable
    end

    it "#edit" do
      expect(get: "/mixtapes/1/edit").to route_to("mixtapes#show", slug: "1/edit")
    end

    it "#update via PUT" do
      expect(put: "/mixtapes/1").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/mixtapes/1").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/mixtapes/1").to_not be_routable
    end
  end
end
