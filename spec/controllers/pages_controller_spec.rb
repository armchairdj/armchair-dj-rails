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
end
