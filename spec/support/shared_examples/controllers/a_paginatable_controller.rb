# frozen_string_literal: true

RSpec.shared_examples "a_paginatable_controller" do
  describe "instance" do
    describe "prevent_duplicate_first_page" do
      it "redirects /page/1 to index" do
        get :index, params: { page: "1" }

        polymorphic_arg = if controller.controller_path.split("/").first == "admin"
          [:admin, controller.send(:determine_model_class)]
        else
          controller.send(:determine_model_class)
        end

        expect(response).to have_http_status(301)
        expect(response).to redirect_to(polymorphic_path(polymorphic_arg))
      end
    end
  end
end
