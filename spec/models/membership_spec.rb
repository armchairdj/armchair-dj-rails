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
    it { should belong_to(:creator) }
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

    it { should validate_presence_of(:creator) }
    it { should validate_presence_of(:member ) }

    it { should validate_uniqueness_of(:creator_id).scoped_to(:member_id) }

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      subject { create_minimal_instance }

      describe "#creator_is_collective" do
        before(:each) do
           allow(subject).to receive(:creator_is_collective).and_call_original
          expect(subject).to receive(:creator_is_collective)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.creator = create(:singular_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_errors(creator_id: :not_collective)
        end
      end

      describe "#member_is_singular" do
        before(:each) do
           allow(subject).to receive(:member_is_singular).and_call_original
          expect(subject).to receive(:member_is_singular)
        end

        specify "valid" do
          expect(subject).to be_valid
        end

        specify "invalid" do
          subject.member = create(:collective_creator)

          expect(subject).to_not be_valid

          expect(subject).to have_errors(member_id: :not_singular)
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
