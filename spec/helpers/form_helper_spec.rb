require "rails_helper"

RSpec.describe FormHelper, type: :helper do
  describe "#required_indicator" do
    specify { expect(helper.required_indicator).to eq(t("simple_form.required.html")) }
  end
end
