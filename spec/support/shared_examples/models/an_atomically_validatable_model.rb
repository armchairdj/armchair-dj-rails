# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "an_atomically_validatable_model" do
  subject { create_minimal_instance }

  describe "methods" do
    describe "valid_attributes?" do
      it { is_expected.to respond_to(:valid_attributes?) }
    end

    describe "valid_attribute?" do
      it { is_expected.to respond_to(:valid_attribute?) }
    end
  end
end
