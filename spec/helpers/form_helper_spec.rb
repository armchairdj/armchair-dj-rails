# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormHelper do
  pending "#button_group"

  pending "#confirm_button"

  describe "#required_indicator" do
    subject { helper.required_indicator }

    it { is_expected.to eq(t("simple_form.required.html")) }
  end

  pending "#submit_button"
end
