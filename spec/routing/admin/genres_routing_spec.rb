require "rails_helper"

RSpec.describe Admin::GenresController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/genres").to route_to("admin/genres#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/genres/new").to route_to("admin/genres#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/genres/1").to route_to("admin/genres#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/genres/1/edit").to route_to("admin/genres#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/genres").to route_to("admin/genres#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/genres/1").to route_to("admin/genres#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/genres/1").to route_to("admin/genres#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/genres/1").to route_to("admin/genres#destroy", :id => "1")
    end

  end
end
