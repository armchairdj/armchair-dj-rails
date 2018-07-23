# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController do
  describe "GET #about" do
    it "renders" do
      get :about

      is_expected.to successfully_render("pages/about")
    end
  end

  describe "GET #credits" do
    it "renders" do
      get :credits

      is_expected.to successfully_render("pages/credits")
    end
  end

  describe "GET #privacy" do
    it "renders" do
      get :privacy

      is_expected.to successfully_render("pages/privacy")
    end
  end

  describe "GET #terms" do
    it "renders" do
      get :terms

      is_expected.to successfully_render("pages/terms")
    end
  end
end
