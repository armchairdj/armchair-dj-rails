# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/playlists").to route_to("playlists#index")
    end

    it "routes to #index pagination" do
      expect(get: "/playlists/page/2").to route_to("playlists#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/playlists/foo/bar/bat").to route_to("playlists#show", slug: "foo/bar/bat")
    end

    describe "does not route to RESTful" do
      it "#new" do
        expect(get: "/playlists/new").to route_to("playlists#show", slug: "new")
      end

      it "#create" do
        expect(post: "/playlists").to_not be_routable
      end

      it "#edit" do
        expect(get: "/playlists/1/edit").to route_to("playlists#show", slug: "1/edit")
      end

      it "#update via PUT" do
        expect(put: "/playlists/1").to_not be_routable
      end

      it "#update via PATCH" do
        expect(patch: "/playlists/1").to_not be_routable
      end

      it "#destroy" do
        expect(delete: "/playlists/1").to_not be_routable
      end
    end
  end
end
