require "rails_helper"

RSpec.describe Milestone, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

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
    it { is_expected.to belong_to(:work) }
  end

  context "attributes" do
    context "enums" do
      it { is_expected.to define_enum_for(:action) }

      it_behaves_like "an_enumable_model", [:action]
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_yearness_of(:year) }

    it { is_expected.to validate_presence_of(:action) }

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end
  end

  context "hooks" do
    # Nothing so far.

    context "callbacks" do
      # Nothing so far.
    end
  end

  context "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
