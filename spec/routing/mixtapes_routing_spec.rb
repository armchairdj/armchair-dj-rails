# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/mixtapes").to route_to("mixtapes#index")
    end

    it "#index pages" do
      expect(get: "/mixtapes/page/2").to route_to("mixtapes#index", page: "2")
    end

    it "#show" do
      expect(get: "/mixtapes/friendly_id").to route_to("mixtapes#show", id: "friendly_id")
    end
  end

  describe "does not route to RESTful" do
    it "#new" do
      expect(get: "/mixtapes/new").to route_to("mixtapes#show", id: "new")
    end

    it "#create" do
      expect(post: "/mixtapes").to_not be_routable
    end

    it "#edit" do
      expect(get: "/mixtapes/friendly_id/edit").to_not be_routable
    end

    it "#update via PUT" do
      expect(put: "/mixtapes/friendly_id").to_not be_routable
    end

    it "#update via PATCH" do
      expect(patch: "/mixtapes/friendly_id").to_not be_routable
    end

    it "#destroy" do
      expect(delete: "/mixtapes/friendly_id").to_not be_routable
    end
  end
end
