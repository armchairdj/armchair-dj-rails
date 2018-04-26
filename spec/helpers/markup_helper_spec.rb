require "rails_helper"

RSpec.describe MarkupHelper, type: :helper do
  describe "#combine_attrs" do
    specify do
      first    = { "data-controller": "byline", class: "strong" }
      last     = { rel: "author", class: "byline" }
      expected = { rel: "author", "data-controller": "byline", class: "strong byline" }
      actual   = helper.combine_attrs(first, last)

      expect(actual).to eq(expected)
    end
  end

  describe "#combine_classes" do
    specify do
      expected = "post published standalone"
      actual   = helper.combine_classes(" post ", "published", " ", nil, ["post", "\n\nstandalone  "])

      expect(actual).to eq(expected)
    end
  end

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

  describe "#paragraphs" do
    specify do
      str      = "\t\n\n   one\n\ntwo\t\t\n\nthree    things\n\n\n"
      expected = "<p>one</p>\n<p>two</p>\n<p>three things</p>"
      actual   = helper.paragraphs(str)

      expect(actual).to eq(expected)
    end
  end
end
