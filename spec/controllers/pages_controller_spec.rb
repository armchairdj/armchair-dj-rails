require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #about" do
    it "renders" do
      get :about

      should successfully_render("pages/about")
    end
  end

  describe "GET #credits" do
    it "renders" do
      get :credits

      should successfully_render("pages/credits")
    end
  end

  describe "GET #privacy" do
    it "renders" do
      get :privacy

      should successfully_render("pages/privacy")
    end
  end

  describe "GET #terms" do
    it "renders" do
      get :terms

      should successfully_render("pages/terms")
    end
  end
end
