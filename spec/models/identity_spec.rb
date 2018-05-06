# frozen_string_literal: true

require "rails_helper"

RSpec.describe Identity, type: :model do
  context "associations" do
    it { should belong_to(:real_name).class_name("Creator") }
    it { should belong_to(:pseudonym).class_name("Creator") }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:real_name) }
    it { should validate_presence_of(:pseudonym) }

    it { should validate_uniqueness_of(:real_name_id).scoped_to(:pseudonym_id) }

    context "custom" do
      subject { create_minimal_instance }

      describe "#real_name_is_primary" do
        before(:each) do
           allow(subject).to receive(:real_name_is_primary).and_call_original
          expect(subject).to receive(:real_name_is_primary)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.real_name = create(:secondary_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_errors(real_name_id: :not_primary)
        end
      end

      describe "#pseudonym_is_secondary" do
        before(:each) do
           allow(subject).to receive(:pseudonym_is_secondary).and_call_original
          expect(subject).to receive(:pseudonym_is_secondary)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.pseudonym = create(:primary_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_errors(pseudonym_id: :not_secondary)
        end
      end
    end
  end
end
