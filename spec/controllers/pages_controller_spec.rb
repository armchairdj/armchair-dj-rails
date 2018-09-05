# frozen_string_literal: true

require "rails_helper"

RSpec.describe PagesController do
  describe "GET #about" do
    it "renders" do
      get :show, params: { template: :about }

      is_expected.to successfully_render("pages/about")
    end
  end

  describe "GET #contact" do
    it "renders" do
      get :show, params: { template: :contact }

      is_expected.to successfully_render("pages/contact")
    end
  end

  describe "GET #credits" do
    it "renders" do
      get :show, params: { template: :credits }

      is_expected.to successfully_render("pages/credits")
    end
  end

  describe "GET #privacy" do
    it "renders" do
      get :show, params: { template: :privacy }

      is_expected.to successfully_render("pages/privacy")
    end
  end

  describe "GET #terms" do
    it "renders" do
      get :show, params: { template: :terms }

      is_expected.to successfully_render("pages/terms")
    end
  end
end
