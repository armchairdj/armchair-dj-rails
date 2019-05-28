# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_authorable_model" do
  describe "associations" do
    it { is_expected.to belong_to(:author) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:author) }

    describe "custom" do
      describe "#author_can_write" do
        let(:instance) { create_minimal_instance }

        before do
          expect(instance).to receive(:author_can_write).and_call_original
        end

        specify "root" do
          instance.author = create(:root)

          expect(instance).to be_valid
        end

        specify "admin" do
          instance.author = create(:admin)

          expect(instance).to be_valid
        end

        specify "editor" do
          instance.author = create(:editor)

          expect(instance).to be_valid
        end

        specify "writer" do
          instance.author = create(:writer)

          expect(instance).to be_valid
        end

        specify "member" do
          instance.author = create(:member)

          expect(instance).to_not be_valid

          expect(instance).to have_error(author: :invalid_author)
        end
      end
    end
  end
end
