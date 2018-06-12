require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/admin/playlists").to route_to("admin/playlists#index")
    end

    it "#new" do
      expect(get: "/admin/playlists/new").to route_to("admin/playlists#new")
    end

    it "#show" do
      expect(get: "/admin/playlists/friendly_id").to route_to("admin/playlists#show", id: "friendly_id")
    end

    it "#edit" do
      expect(get: "/admin/playlists/friendly_id/edit").to route_to("admin/playlists#edit", id: "friendly_id")
    end

    it "#create" do
      expect(post: "/admin/playlists").to route_to("admin/playlists#create")
    end

    it "#update via PUT" do
      expect(put: "/admin/playlists/friendly_id").to route_to("admin/playlists#update", id: "friendly_id")
    end

    it "#update via PATCH" do
      expect(patch: "/admin/playlists/friendly_id").to route_to("admin/playlists#update", id: "friendly_id")
    end

    it "#destroy" do
      expect(delete: "/admin/playlists/friendly_id").to route_to("admin/playlists#destroy", id: "friendly_id")
    end
  end
end
