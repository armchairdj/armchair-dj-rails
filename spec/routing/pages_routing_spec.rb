require "rails_helper"

RSpec.describe PagesController, type: :routing do
  describe 'routing' do

    it "routes to #about" do
      expect(get: "/about").to route_to("pages#about")
    end

    it "routes to #credits" do
      expect(get: "/credits").to route_to("pages#credits")
    end
  end
end
