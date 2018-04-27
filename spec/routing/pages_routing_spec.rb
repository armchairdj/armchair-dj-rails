# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :routing do
  describe "routing" do
    it "routes to #about" do
      expect(get: "/about").to route_to("pages#about")
    end

    it "routes to #credits" do
      expect(get: "/credits").to route_to("pages#credits")
    end

    it "routes to #privacy" do
      expect(get: "/privacy").to route_to("pages#privacy")
    end

    it "routes to #terms" do
      expect(get: "/terms").to route_to("pages#terms")
    end
  end
end
