# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController, type: :routing do
  describe "routes to" do
    it "#about" do
      expect(get: "/about").to route_to("pages#about")
    end

    it "#credits" do
      expect(get: "/credits").to route_to("pages#credits")
    end

    it "#privacy" do
      expect(get: "/privacy").to route_to("pages#privacy")
    end

    it "#terms" do
      expect(get: "/terms").to route_to("pages#terms")
    end
  end
end
