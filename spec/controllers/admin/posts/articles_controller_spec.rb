# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ArticlesController do
  it_behaves_like "an_admin_post_controller" do
    let(:bad_update_params) { { "body" => "", "title" => "" } }
  end

  it_behaves_like "a_paginatable_controller"
end
