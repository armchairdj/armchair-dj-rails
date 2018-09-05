# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController do
  describe "routes to" do
    it "#about" do
      expect(get: "/about").to route_to("pages#show", template: "about")
    end

    it "#contact" do
      expect(get: "/contact").to route_to("pages#show", template: "contact")
    end

    it "#credits" do
      expect(get: "/credits").to route_to("pages#show", template: "credits")
    end

    it "#privacy" do
      expect(get: "/privacy").to route_to("pages#show", template: "privacy")
    end

    it "#terms" do
      expect(get: "/terms").to route_to("pages#show", template: "terms")
    end
  end
end
