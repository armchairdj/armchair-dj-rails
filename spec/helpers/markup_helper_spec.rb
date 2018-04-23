require "rails_helper"

RSpec.describe MarkupHelper, type: :helper do
  describe "#content_for_unless_empty" do
    it "yields" do
      helper.content_for(:full, "full")

      expected = "full"
      actual   = helper.content_for_unless_empty(:full)

      expect(actual).to eq(expected)
    end

    it "wraps" do
      helper.content_for(:full, "full")

      expected = "<div>full</div>"
      actual   = helper.content_for_unless_empty(:full, wrapper: :div)

      expect(actual).to eq(expected)
    end

    it "wraps with options" do
      helper.content_for(:full, "full")

      expected = '<div class="foo">full</div>'
      actual   = helper.content_for_unless_empty(:full, wrapper: :div, class: "foo")

      expect(actual).to eq(expected)
    end

    it "nils" do
      expect(helper.content_for_unless_empty(:empty)).to eq(nil)
    end

    it "nils with wrapper" do
      expect(helper.content_for_unless_empty(:empty, wrapper: :div)).to eq(nil)
    end
  end

  pending "#combine_attrs"

  pending "#combine_classes"
end
