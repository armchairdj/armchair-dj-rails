# frozen_string_literal: true

require "rails_helper"

RSpec.describe StyleGuidesController, type: :routing do
  describe "routes to" do
    it "#index" do
      expect(get: "/style_guide").to route_to("style_guides#index")
    end

    describe "template" do
      it "#button" do
        expect(get: "/style_guide/button").to route_to("style_guides#show", template: "button")
      end

      it "#form" do
        expect(get: "/style_guide/form").to route_to("style_guides#show", template: "form")
      end

      it "#form_error" do
        expect(get: "/style_guide/form_error").to route_to("style_guides#show", template: "form_error")
      end

      it "#grid" do
        expect(get: "/style_guide/grid").to route_to("style_guides#show", template: "grid")
      end

      it "#headline" do
        expect(get: "/style_guide/headline").to route_to("style_guides#show", template: "headline")
      end

      it "#list" do
        expect(get: "/style_guide/list").to route_to("style_guides#show", template: "list")
      end

      it "#article" do
        expect(get: "/style_guide/post").to route_to("style_guides#show", template: "post")
      end

      it "#quotation" do
        expect(get: "/style_guide/quotation").to route_to("style_guides#show", template: "quotation")
      end

      it "#svg" do
        expect(get: "/style_guide/svg").to route_to("style_guides#show", template: "svg")
      end

      it "#tabs" do
        expect(get: "/style_guide/tabs").to route_to("style_guides#show", template: "tabs")
      end

      it "#text" do
        expect(get: "/style_guide/text").to route_to("style_guides#show", template: "text")
      end
    end

    describe "#flash_message" do
      it "#alert" do
        expect(get: "/style_guide/flash/alert").to route_to("style_guides#flash_message", flash_type: "alert")
      end

      it "#error" do
        expect(get: "/style_guide/flash/error").to route_to("style_guides#flash_message", flash_type: "error")
      end

      it "#info" do
        expect(get: "/style_guide/flash/info").to route_to("style_guides#flash_message", flash_type: "info")
      end

      it "#notice" do
        expect(get: "/style_guide/flash/notice").to route_to("style_guides#flash_message", flash_type: "notice")
      end

      it "#success" do
        expect(get: "/style_guide/flash/success").to route_to("style_guides#flash_message", flash_type: "success")
      end
    end

    describe "#error_page" do
      it "#bad_request" do
        expect(get: "/style_guide/error/bad_request").to route_to("style_guides#error_page", error_type: "bad_request")
      end

      it "#internal_server_error" do
        expect(get: "/style_guide/error/internal_server_error").to route_to("style_guides#error_page", error_type: "internal_server_error")
      end

      it "#not_found" do
        expect(get: "/style_guide/error/not_found").to route_to("style_guides#error_page", error_type: "not_found")
      end

      it "#permission_denied" do
        expect(get: "/style_guide/error/permission_denied").to route_to("style_guides#error_page", error_type: "permission_denied")
      end
    end
  end
end
