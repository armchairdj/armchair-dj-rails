# frozen_string_literal: true

require "rails_helper"

RSpec.describe Identity, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:real_name).class_name("Creator") }
    it { is_expected.to belong_to(:pseudonym).class_name("Creator") }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:real_name) }
    it { is_expected.to validate_presence_of(:pseudonym) }

    it { is_expected.to validate_uniqueness_of(:real_name_id).scoped_to(:pseudonym_id) }

    context "custom" do
      subject { create_minimal_instance }

      describe "#real_name_is_primary" do
        before(:each) do
           allow(subject).to receive(:real_name_is_primary).and_call_original
          is_expected.to receive(:real_name_is_primary)
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.real_name = create(:secondary_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(real_name_id: :not_primary)
        end
      end

      describe "#pseudonym_is_secondary" do
        before(:each) do
           allow(subject).to receive(:pseudonym_is_secondary).and_call_original
          is_expected.to receive(:pseudonym_is_secondary)
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.pseudonym = create(:primary_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(pseudonym_id: :not_secondary)
        end
      end
    end
  end
end
