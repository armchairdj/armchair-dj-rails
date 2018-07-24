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
        subject { create_minimal_instance }

        before(:each) do
          expect(subject).to receive(:author_can_write).and_call_original
        end

        specify "root" do
          subject.author = create(:root)

          expect(subject).to be_valid
        end

        specify "admin" do
          subject.author = create(:admin)

          expect(subject).to be_valid
        end

        specify "editor" do
          subject.author = create(:editor)

          expect(subject).to be_valid
        end

        specify "writer" do
          subject.author = create(:editor)

          expect(subject).to be_valid
        end

        specify "member" do
          subject.author = create(:member)

          expect(subject).to_not be_valid

          expect(subject).to have_error(author: :invalid_author)
        end
      end
    end
  end
end
