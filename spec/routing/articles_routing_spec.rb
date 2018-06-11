# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesController, type: :routing do
  describe "routes to" do
    it "homepage" do
      expect(get: "/").to route_to("articles#index")
    end

    it "#index pages" do
      expect(get: "/page/2").to route_to("articles#index", page: "2")
    end

    it "#show" do
      expect(get: "/articles/foo/bar/bat").to route_to("articles#show", slug: "foo/bar/bat")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/articles/new").to route_to("articles#show", slug: "new")
    end

    it "#create" do
      expect(post: "/articles").to_not be_routable
    end

    it "#edit" do
      expect(get: "/articles/1/edit").to route_to("articles#show", slug: "1/edit")
    end

    it "#update via PUT" do
      expect(put: "/articles/1").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/articles/1").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/articles/1").to_not be_routable
    end
  end
end
