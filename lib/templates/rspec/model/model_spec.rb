require "rails_helper"

<% module_namespacing do -%>
RSpec.describe <%= class_name %>, <%= type_metatag(:model) %> do
  pending "add some examples to (or delete) #{__FILE__}"

  describe "constants" do
    # Nothing so far.
  end

  describe "concerns" do
    # Nothing so far.
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    # Nothing so far.
  end

  describe "associations" do
    # Nothing so far.
  end

  describe "attributes" do
    describe "nested" do
      # Nothing so far.
    end

    describe "enums" do
      # Nothing so far.
    end
  end

  describe "validations" do
    # Nothing so far.

    describe "conditional" do
      # Nothing so far.
    end

    describe "custom" do
      # Nothing so far.
    end
  end

  describe "hooks" do
    # Nothing so far.

    describe "callbacks" do
      # Nothing so far.
    end
  end

  describe "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
<% end -%>
