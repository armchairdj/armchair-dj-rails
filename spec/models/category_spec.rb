require "rails_helper"

RSpec.describe Category, type: :model do
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
    it { should have_many(:facets) }

    it { should have_many(:media).through(:facets) }

    it { should have_many(:tags) }
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
    subject { create_minimal_instance }

    it { should validate_presence_of(:name) }

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
