# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_summarizable_model" do
  subject { create_minimal_instance }

  describe "included" do
    describe "validations" do
      it { is_expected.to validate_length_of(:summary).is_at_least(40).is_at_most(320) }
      it { is_expected.to allow_value("", nil).for(:summary) }
    end
  end
end
