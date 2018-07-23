# frozen_string_literal: true

require "rails_helper"

RSpec.describe StyleGuidesController do
  context "as root" do
    login_writer

    describe "GET #index" do
      it "renders" do
        get :index

        is_expected.to successfully_render("style_guides/index")
      end
    end

    describe "GET #show" do
      it "renders button" do
        get :show, params: { template: "button" }

        is_expected.to successfully_render("style_guides/button")
      end

      it "renders form" do
        get :show, params: { template: "form" }

        is_expected.to successfully_render("style_guides/form")
      end

      it "renders form_error" do
        get :show, params: { template: "form_error" }

        is_expected.to successfully_render("style_guides/form_error")
      end

      it "renders headline" do
        get :show, params: { template: "headline" }

        is_expected.to successfully_render("style_guides/headline")
      end

      it "renders list" do
        get :show, params: { template: "list" }

        is_expected.to successfully_render("style_guides/list")
      end

      it "renders article" do
        get :show, params: { template: "post" }

        is_expected.to successfully_render("style_guides/post")
      end

      it "renders quotation" do
        get :show, params: { template: "quotation" }

        is_expected.to successfully_render("style_guides/quotation")
      end

      it "renders svg" do
        get :show, params: { template: "svg" }

        is_expected.to successfully_render("style_guides/svg")
      end

      it "renders text" do
        get :show, params: { template: "text" }

        is_expected.to successfully_render("style_guides/text")
      end
    end

    describe "GET #error_page" do
      it "renders bad_request" do
        get :error_page, params: { error_type: "bad_request" }

        is_expected.to successfully_render("errors/bad_request")
      end

      it "renders internal_server_error" do
        get :error_page, params: { error_type: "internal_server_error" }

        is_expected.to successfully_render("errors/internal_server_error")
      end

      it "renders not_found" do
        get :error_page, params: { error_type: "not_found" }

        is_expected.to successfully_render("errors/not_found")
      end

      it "renders permission_denied" do
        get :error_page, params: { error_type: "permission_denied" }

        is_expected.to successfully_render("errors/permission_denied")
      end
    end

    describe "GET #flash_message" do
      it "renders alert" do
        get :flash_message, params: { flash_type: "alert" }

        is_expected.to successfully_render("style_guides/flash_message")

        expect(flash[:alert]).to eq("This is a flash alert message.")
      end

      it "renders error" do
        get :flash_message, params: { flash_type: "error" }

        is_expected.to successfully_render("style_guides/flash_message")

        expect(flash[:error]).to eq("This is a flash error message.")
      end

      it "renders info" do
        get :flash_message, params: { flash_type: "info" }

        is_expected.to successfully_render("style_guides/flash_message")

        expect(flash[:info]).to eq("This is a flash info message.")
      end

      it "renders notice" do
        get :flash_message, params: { flash_type: "notice" }

        is_expected.to successfully_render("style_guides/flash_message")

        expect(flash[:notice]).to eq("This is a flash notice message.")
      end

      it "renders success" do
        get :flash_message, params: { flash_type: "success" }

        is_expected.to successfully_render("style_guides/flash_message")

        expect(flash[:success]).to eq("This is a flash success message.")
      end
    end
  end
end
