# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Posts::MixtapesController, type: :controller do
  describe "concerns" do
    it_behaves_like "an_admin_controller"

    it_behaves_like "an_admin_post_controller" do
      let(:bad_update_params) { { "body" => "", "playlist_id" => "" } }

      let(:expected_unpublish_errors) { { playlist: :blank } }
      let(:expected_publish_errors  ) { { playlist: :blank, body: :blank } }
    end

    it_behaves_like "a_linkable_controller"

    it_behaves_like "a_paginatable_controller"
  end

  describe "helpers" do
    describe "#allowed_sorts" do
      subject { described_class.new.send(:allowed_sorts) }

      specify "keys are short sort names" do
        expect(subject.keys).to match_array([
          "Title",
          "Author",
          "Status",
        ])
      end
    end
  end
end
