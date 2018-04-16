require "rails_helper"

RSpec.describe CreatorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/creators").to route_to("creators#index")
    end

    it "routes to #index pages" do
      expect(get: "/creators/page/2").to route_to("creators#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/creators/1").to route_to("creators#show", id: "1")
    end

    describe "does not route to RESTful" do
      it "#new" do
        expect(get: "/creators/new").to route_to("creators#show", id: "new")
      end

      it "#create" do
        expect(post: "/creators").to_not be_routable
      end

      it "#edit" do
        expect(get: "/creators/1/edit").to_not be_routable
      end

      it "#update via PUT" do
        expect(put: "/creators/1").to_not be_routable
      end

      it "#update via PATCH" do
        expect(patch: "/creators/1").to_not be_routable
      end

      it "#destroy" do
        expect(delete: "/creators/1").to_not be_routable
      end
    end
  end
end
