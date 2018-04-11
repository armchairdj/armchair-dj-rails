require 'rails_helper'

RSpec.describe StyleGuidesController, type: :controller do
  context "as admin" do
    login_admin

    describe 'GET #index' do
      it "renders" do
        get :index

        expect(response).to be_success
        expect(response).to render_template("style_guides/index")
      end
    end

    describe 'GET #show' do
      it "renders button" do
        get :show, params: { template: "button" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/button")
      end

      it "renders form" do
        get :show, params: { template: "form" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/form")
      end

      it "renders form_error" do
        get :show, params: { template: "form_error" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/form_error")
      end

      it "renders headline" do
        get :show, params: { template: "headline" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/headline")
      end

      it "renders list" do
        get :show, params: { template: "list" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/list")
      end

      it "renders post" do
        get :show, params: { template: "post" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/post")
      end

      it "renders quotation" do
        get :show, params: { template: "quotation" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/quotation")
      end

      it "renders svg" do
        get :show, params: { template: "svg" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/svg")
      end

      it "renders text" do
        get :show, params: { template: "text" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/text")
      end
    end

    describe 'GET #error_page' do
      it "renders bad_request" do
        get :error_page, params: { error_type: "bad_request" }

        expect(response).to be_success
        expect(response).to render_template("errors/bad_request")
      end

      it "renders internal_server_error" do
        get :error_page, params: { error_type: "internal_server_error" }

        expect(response).to be_success
        expect(response).to render_template("errors/internal_server_error")
      end

      it "renders not_found" do
        get :error_page, params: { error_type: "not_found" }

        expect(response).to be_success
        expect(response).to render_template("errors/not_found")
      end

      it "renders permission_denied" do
        get :error_page, params: { error_type: "permission_denied" }

        expect(response).to be_success
        expect(response).to render_template("errors/permission_denied")
      end
    end

    describe 'GET #flash_message' do
      it "renders alert" do
        get :flash_message, params: { flash_type: "alert" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/flash_message")

        expect(flash[:alert]).to eq("This is a flash alert message.")
      end

      it "renders error" do
        get :flash_message, params: { flash_type: "error" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/flash_message")

        expect(flash[:error]).to eq("This is a flash error message.")
      end

      it "renders info" do
        get :flash_message, params: { flash_type: "info" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/flash_message")

        expect(flash[:info]).to eq("This is a flash info message.")
      end

      it "renders notice" do
        get :flash_message, params: { flash_type: "notice" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/flash_message")

        expect(flash[:notice]).to eq("This is a flash notice message.")
      end

      it "renders success" do
        get :flash_message, params: { flash_type: "success" }

        expect(response).to be_success
        expect(response).to render_template("style_guides/flash_message")

        expect(flash[:success]).to eq("This is a flash success message.")
      end
    end
  end
end
