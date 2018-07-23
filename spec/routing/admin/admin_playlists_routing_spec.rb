require "rails_helper"

RSpec.describe Admin::PlaylistsController do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/playlists").to route_to("admin/playlists#index")
    end

    it "#new" do
      expect(get: "/admin/playlists/new").to route_to("admin/playlists#new")
    end

    it "#show" do
      expect(get: "/admin/playlists/1").to route_to("admin/playlists#show", id: "1")
    end

    it "#edit" do
      expect(get: "/admin/playlists/1/edit").to route_to("admin/playlists#edit", id: "1")
    end

    it "#create" do
      expect(post: "/admin/playlists").to route_to("admin/playlists#create")
    end

    it "#update via PUT" do
      expect(put: "/admin/playlists/1").to route_to("admin/playlists#update", id: "1")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/playlists/1").to route_to("admin/playlists#update", id: "1")
    end

    it "#reorder_playlistings" do
      expect(post: "/admin/playlists/1/reorder_playlistings").to route_to("admin/playlists#reorder_playlistings", id: "1")
    end

    it "#destroy" do
      expect(delete: "/admin/playlists/1").to route_to("admin/playlists#destroy", id: "1")
    end
  end
end
