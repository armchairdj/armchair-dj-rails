# frozen_string_literal: true

RSpec.shared_examples "an_seo_paginatable_controller" do
  describe "instance" do
    describe "prevent_duplicate_first_page" do
      it "redirects /page/1 to index" do
        get :index, params: { page: "1" }

        expect(response).to have_http_status(301)
        expect(response).to redirect_to(expected_redirect)
      end
    end
  end
end
