# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/playlists").to route_to("playlists#index")
    end

    it "#index pages" do
      expect(get: "/playlists/page/2").to route_to("playlists#index", page: "2")
    end

    it "#show" do
      expect(get: "/playlists/friendly_id").to route_to("playlists#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/playlists/new").to route_to("playlists#show", id: "new")
    end

    it "#create" do
      expect(post: "/playlists").to_not be_routable
    end

    it "#edit" do
      expect(get: "/playlists/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/playlists/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/playlists/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/playlists/friendly_id").to_not be_routable
    end
  end
end
