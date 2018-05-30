# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/works").to route_to("works#index")
    end

    it "routes to #index pagination" do
      expect(get: "/works/page/2").to route_to("works#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/works/foo/bar/bat").to route_to("works#show", slug: "foo/bar/bat")
    end

    describe "does not route to RESTful" do
      it "#new" do
        expect(get: "/works/new").to route_to("works#show", slug: "new")
      end

      it "#create" do
        expect(post: "/works").to_not be_routable
      end

      it "#edit" do
        expect(get: "/works/1/edit").to route_to("works#show", slug: "1/edit")
      end

      it "#update via PUT" do
        expect(put: "/works/1").to_not be_routable
      end

      it "#update via PATCH" do
        expect(patch: "/works/1").to_not be_routable
      end

      it "#destroy" do
        expect(delete: "/works/1").to_not be_routable
      end
    end
  end
end
