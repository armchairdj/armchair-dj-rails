require "rails_helper"

RSpec.shared_examples "an atomically validatable model" do
  let(:instance) { create_minimal_instance }

  describe "instance" do
    describe "valid_attributes?" do
      pending "validates one attribute"
      pending "validates multiple attributes"
      pending "does not validate other attributes"
      pending "returns false if any passed attribute is invalid"
      pending "returns true if all passed attributes are valid"
      pending "returns true even if other attributes are invalid"
    end

    describe "valid_attribute?" do
      pending "convenience method for single attribute"
    end
  end
end
