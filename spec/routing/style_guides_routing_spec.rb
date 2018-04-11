require "rails_helper"

RSpec.describe StyleGuidesController, type: :routing do
  describe 'routing' do

    it "routes to #index" do
      expect(get: "/style_guide").to route_to("style_guides#index")
    end

    context "template" do
      it "routes to #button" do
        expect(get: "/style_guide/button").to route_to("style_guides#show", template: "button")
      end

      it "routes to #form" do
        expect(get: "/style_guide/form").to route_to("style_guides#show", template: "form")
      end

      it "routes to #form_error" do
        expect(get: "/style_guide/form_error").to route_to("style_guides#show", template: "form_error")
      end

      it "routes to #headline" do
        expect(get: "/style_guide/headline").to route_to("style_guides#show", template: "headline")
      end

      it "routes to #list" do
        expect(get: "/style_guide/list").to route_to("style_guides#show", template: "list")
      end

      it "routes to #post" do
        expect(get: "/style_guide/post").to route_to("style_guides#show", template: "post")
      end

      it "routes to #quotation" do
        expect(get: "/style_guide/quotation").to route_to("style_guides#show", template: "quotation")
      end

      it "routes to #svg" do
        expect(get: "/style_guide/svg").to route_to("style_guides#show", template: "svg")
      end

      it "routes to #text" do
        expect(get: "/style_guide/text").to route_to("style_guides#show", template: "text")
      end
    end

    context "#flash_message" do
      it "routes to #alert" do
        expect(get: "/style_guide/flash/alert").to route_to("style_guides#flash_message", flash_type: "alert")
      end

      it "routes to #error" do
        expect(get: "/style_guide/flash/error").to route_to("style_guides#flash_message", flash_type: "error")
      end

      it "routes to #info" do
        expect(get: "/style_guide/flash/info").to route_to("style_guides#flash_message", flash_type: "info")
      end

      it "routes to #notice" do
        expect(get: "/style_guide/flash/notice").to route_to("style_guides#flash_message", flash_type: "notice")
      end

      it "routes to #success" do
        expect(get: "/style_guide/flash/success").to route_to("style_guides#flash_message", flash_type: "success")
      end
    end

    context "#error_page" do
      it "routes to #bad_request" do
        expect(get: "/style_guide/error/bad_request").to route_to("style_guides#error_page", error_type: "bad_request")
      end

      it "routes to #internal_server_error" do
        expect(get: "/style_guide/error/internal_server_error").to route_to("style_guides#error_page", error_type: "internal_server_error")
      end

      it "routes to #not_found" do
        expect(get: "/style_guide/error/not_found").to route_to("style_guides#error_page", error_type: "not_found")
      end

      it "routes to #permission_denied" do
        expect(get: "/style_guide/error/permission_denied").to route_to("style_guides#error_page", error_type: "permission_denied")
      end
    end
  end
end
