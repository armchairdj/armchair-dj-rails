# frozen_string_literal: true

require "rails_helper"

RSpec.describe Membership, type: :model do
  context "associations" do
    it { should belong_to(:group ).class_name("Creator") }
    it { should belong_to(:member).class_name("Creator") }
  end

  context "validations" do
    subject { create_minimal_instance }

    it { should validate_presence_of(:group ) }
    it { should validate_presence_of(:member) }

    it { should validate_uniqueness_of(:group_id).scoped_to(:member_id) }

    context "custom" do
      subject { create_minimal_instance }

      describe "#group_is_collective" do
        before(:each) do
           allow(subject).to receive(:group_is_collective).and_call_original
          expect(subject).to receive(:group_is_collective)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.group = create(:individual_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_error(group_id: :not_collective)
        end
      end

      describe "#member_is_individual" do
        before(:each) do
           allow(subject).to receive(:member_is_individual).and_call_original
          expect(subject).to receive(:member_is_individual)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.member = create(:collective_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_error(member_id: :not_individual)
        end
      end
    end
  end
end
