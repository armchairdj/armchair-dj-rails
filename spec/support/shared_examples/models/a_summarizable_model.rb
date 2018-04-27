# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_summarizable_model" do
  subject { create_minimal_instance }

  describe "included" do
    describe "validations" do
      it { should validate_length_of :summary }
      it { should allow_value("", nil).for(:summary) }
    end
  end
end
