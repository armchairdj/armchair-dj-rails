# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/tags").to route_to("tags#index")
    end

    it "routes to #index pagination" do
      expect(get: "/tags/page/2").to route_to("tags#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/tags/1").to route_to("tags#show", id: "1")
    end

    describe "does not route to RESTful" do
      it "#new" do
        expect(get: "/tags/new").to route_to("tags#show", id: "new")
      end

      it "#create" do
        expect(post: "/tags").to_not be_routable
      end

      it "#edit" do
        expect(get: "/tags/1/edit").to_not be_routable
      end

      it "#update via PUT" do
        expect(put: "/tags/1").to_not be_routable
      end

      it "#update via PATCH" do
        expect(patch: "/tags/1").to_not be_routable
      end

      it "#destroy" do
        expect(delete: "/tags/1").to_not be_routable
      end
    end
  end
end
