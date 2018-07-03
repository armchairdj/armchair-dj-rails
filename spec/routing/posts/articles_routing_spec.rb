# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::ArticlesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/articles").to route_to("posts/articles#index")
    end

    it "#index pages" do
      expect(get: "/articles/page/2").to route_to("posts/articles#index", page: "2")
    end

    it "#show" do
      expect(get: "/articles/friendly_id").to route_to("posts/articles#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/articles/new").to route_to("posts/articles#show", id: "new")
    end

    it "#create" do
      expect(post: "/articles").to_not be_routable
    end

    it "#edit" do
      expect(get: "/articles/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/articles/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/articles/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/articles/friendly_id").to_not be_routable
    end
  end
end
