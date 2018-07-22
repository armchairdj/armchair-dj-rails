# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ReviewsController, type: :controller do
  describe "concerns" do
    it_behaves_like "an_admin_post_controller" do
      let(:bad_update_params) { { "body" => "", "work_id" => "" } }

      let(:expected_unpublish_errors) { { work: :blank } }
      let(:expected_publish_errors  ) { { work: :blank, body: :blank } }
    end

    it_behaves_like "a_linkable_controller"

    it_behaves_like "a_paginatable_controller"
  end
end
