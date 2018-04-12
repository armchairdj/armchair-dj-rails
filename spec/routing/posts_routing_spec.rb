require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe 'routing' do
    it "routes to homepage" do
      expect(get: "/").to route_to("posts#index")
    end

    it "routes to #index pages" do
      expect(get: "/page/2").to route_to("posts#index", page: "2")
    end

    it "routes to #show" do
      expect(get: "/posts/foo/bar/bat").to route_to("posts#show", slug: "foo/bar/bat")
    end

    describe "does not route to RESTful" do
      it "#new" do
        expect(get: "/posts/new").to route_to("posts#show", slug: "new")
      end

      it "#create" do
        expect(post: "/posts").to_not be_routable
      end

      it "#edit" do
        expect(get: "/posts/1/edit").to route_to("posts#show", slug: "1/edit")
      end

      it "#update via PUT" do
        expect(put: "/posts/1").to_not be_routable
      end

      it "#update via PATCH" do
        expect(patch: "/posts/1").to_not be_routable
      end

      it "#destroy" do
        expect(delete: "/posts/1").to_not be_routable
      end
    end
  end
end
