# frozen_string_literal: true

require "rails_helper"

RSpec.describe Membership, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    # Nothing so far.
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    # Nothing so far.
  end

  context "associations" do
    it { should belong_to(:group ).class_name("Creator") }
    it { should belong_to(:member).class_name("Creator") }
  end

  context "attributes" do
    context "nested" do
      # Nothing so far.
    end

    context "enums" do
      # Nothing so far.
    end
  end

  context "validations" do
    subject { build_minimal_instance }

    it { should validate_presence_of(:group ) }
    it { should validate_presence_of(:member) }

    it { should validate_uniqueness_of(:group_id).scoped_to(:member_id) }

    context "conditional" do
      # Nothing so far.
    end

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

          expect(subject).to have_errors(group_id: :not_collective)
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

          expect(subject).to have_errors(member_id: :not_individual)
        end
      end
    end
  end

  context "hooks" do
    # Nothing so far.
  end

  context "instance" do
    describe "private" do
      # Nothing so far.
    end
  end
end
