# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorsController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/creators").to route_to("creators#index")
    end

    it "#index pages" do
      expect(get: "/creators/page/2").to route_to("creators#index", page: "2")
    end

    it "#show" do
      expect(get: "/creators/friendly_id").to route_to("creators#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/creators/new").to route_to("creators#show", id: "new")
    end

    it "#create" do
      expect(post: "/creators").to_not be_routable
    end

    it "#edit" do
      expect(get: "/creators/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/creators/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/creators/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/creators/friendly_id").to_not be_routable
    end
  end
end
