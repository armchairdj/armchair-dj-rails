# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::ArticlesController, type: :controller do
  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_admin_post_controller" do
      let(:bad_create_params) { minimal_attributes.except(:author_id, :title) }
      let(    :update_params) { { "body" => "New body.", "title" => "New title" } }
      let(:bad_update_params) { { "body" => "", "title" => "" } }

      let(:invalid_unpublish_errors) { { title: :blank } }
      let(:invalid_publish_errors  ) { { title: :blank, body: :blank } }
    end

    it_behaves_like "a_linkable_controller"

    it_behaves_like "a_paginatable_controller"
  end

  describe "helpers" do
    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Default",
          "ID",
          "Title",
          "Author",
          "Status",
        ])
      end
    end
  end
end
