require "rails_helper"

RSpec.describe Genre, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_summarizable_model"

    # it_behaves_like "a_viewable_model"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    pending "self#eager"
    pending "self#for_admin"
    pending "self#for_site"
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
    pending "#alpha_parts"

    describe "private" do
      # Nothing so far.
    end
  end
end
