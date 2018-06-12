# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/works").to route_to("works#index")
    end

    it "#index pages" do
      expect(get: "/works/page/2").to route_to("works#index", page: "2")
    end

    it "#show" do
      expect(get: "/works/friendly_id").to route_to("works#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/works/new").to route_to("works#show", id: "new")
    end

    it "#create" do
      expect(post: "/works").to_not be_routable
    end

    it "#edit" do
      expect(get: "/works/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/works/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/works/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/works/friendly_id").to_not be_routable
    end
  end
end
