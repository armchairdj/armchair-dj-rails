# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ReviewsController do
  it_behaves_like "an_admin_post_controller" do
    let(:bad_update_params) { { "body" => "", "work_id" => "" } }
  end

  it_behaves_like "a_paginatable_controller"
end
