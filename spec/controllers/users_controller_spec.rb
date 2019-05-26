# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersController do
  context "published writer" do
    let(:user) { create(:writer, :with_published_post) }

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: user.to_param }

        is_expected.to successfully_render("users/show")
      end
    end
  end

  context "unpublished writer" do
    let(:user) { create(:writer) }

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: user.to_param }

        is_expected.to render_not_found
      end
    end
  end

  context "non-writer" do
    let(:user) { create(:member) }

    describe "GET #show" do
      it "renders" do
        get :show, params: { id: user.to_param }

        is_expected.to render_not_found
      end
    end
  end
end
