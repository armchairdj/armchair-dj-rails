# frozen_string_literal: true

require "rails_helper"

RSpec.describe StyleGuidesController, type: :controller do
  context "as admin" do
    login_admin

    describe "GET #index" do
      it "renders" do
        get :index

        should successfully_render("style_guides/index")
      end
    end

    describe "GET #show" do
      it "renders button" do
        get :show, params: { template: "button" }

        should successfully_render("style_guides/button")
      end

      it "renders form" do
        get :show, params: { template: "form" }

        should successfully_render("style_guides/form")
      end

      it "renders form_error" do
        get :show, params: { template: "form_error" }

        should successfully_render("style_guides/form_error")
      end

      it "renders headline" do
        get :show, params: { template: "headline" }

        should successfully_render("style_guides/headline")
      end

      it "renders list" do
        get :show, params: { template: "list" }

        should successfully_render("style_guides/list")
      end

      it "renders post" do
        get :show, params: { template: "post" }

        should successfully_render("style_guides/post")
      end

      it "renders quotation" do
        get :show, params: { template: "quotation" }

        should successfully_render("style_guides/quotation")
      end

      it "renders svg" do
        get :show, params: { template: "svg" }

        should successfully_render("style_guides/svg")
      end

      it "renders text" do
        get :show, params: { template: "text" }

        should successfully_render("style_guides/text")
      end
    end

    describe "GET #error_page" do
      it "renders bad_request" do
        get :error_page, params: { error_type: "bad_request" }

        should successfully_render("errors/bad_request")
      end

      it "renders internal_server_error" do
        get :error_page, params: { error_type: "internal_server_error" }

        should successfully_render("errors/internal_server_error")
      end

      it "renders not_found" do
        get :error_page, params: { error_type: "not_found" }

        should successfully_render("errors/not_found")
      end

      it "renders permission_denied" do
        get :error_page, params: { error_type: "permission_denied" }

        should successfully_render("errors/permission_denied")
      end
    end

    describe "GET #flash_message" do
      it "renders alert" do
        get :flash_message, params: { flash_type: "alert" }

        should successfully_render("style_guides/flash_message")

        expect(flash[:alert]).to eq("This is a flash alert message.")
      end

      it "renders error" do
        get :flash_message, params: { flash_type: "error" }

        should successfully_render("style_guides/flash_message")

        expect(flash[:error]).to eq("This is a flash error message.")
      end

      it "renders info" do
        get :flash_message, params: { flash_type: "info" }

        should successfully_render("style_guides/flash_message")

        expect(flash[:info]).to eq("This is a flash info message.")
      end

      it "renders notice" do
        get :flash_message, params: { flash_type: "notice" }

        should successfully_render("style_guides/flash_message")

        expect(flash[:notice]).to eq("This is a flash notice message.")
      end

      it "renders success" do
        get :flash_message, params: { flash_type: "success" }

        should successfully_render("style_guides/flash_message")

        expect(flash[:success]).to eq("This is a flash success message.")
      end
    end
  end
end
