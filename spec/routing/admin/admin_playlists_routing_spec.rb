require "rails_helper"

RSpec.describe Admin::PlaylistsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/playlists").to route_to("admin/playlists#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/playlists/new").to route_to("admin/playlists#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/playlists/1").to route_to("admin/playlists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/playlists/1/edit").to route_to("admin/playlists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/playlists").to route_to("admin/playlists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/playlists/1").to route_to("admin/playlists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/playlists/1").to route_to("admin/playlists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/playlists/1").to route_to("admin/playlists#destroy", :id => "1")
    end
  end
end
