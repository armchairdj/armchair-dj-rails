require "rails_helper"

RSpec.describe Playlist, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_authorable_model"

    it_behaves_like "a_displayable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    # Nothing so far.
  end

  context "associations" do
    # Nothing so far.
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
    # Nothing so far.

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
