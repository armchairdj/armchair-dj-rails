# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::PostsController do
  describe "routes to" do
    it "#index" do
      expect(get: "/").to route_to("posts/posts#index")
    end

    it "#index pages" do
      expect(get: "/page/2").to route_to("posts/posts#index", page: "2")
    end

    it "#feed" do
      expect(get: "/feed.rss").to route_to("posts/posts#feed", format: "rss")
    end
  end

  describe "does not route to RESTful" do
    it "#show" do
      expect(get: "/posts/friendly_id").to_not be_routable
    end

    it "#new" do
      expect(get: "/posts/new").to_not be_routable
    end

    it "#create" do
      expect(post: "/posts").to_not be_routable
    end

    it "#edit" do
      expect(get: "/posts/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/posts/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/posts/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/posts/friendly_id").to_not be_routable
    end
  end
end
