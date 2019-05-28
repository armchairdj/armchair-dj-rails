# frozen_string_literal: true

require "rails_helper"

RSpec.describe MarkupHelper do
  describe "#blockquote" do
    context "with block" do
      pending "renders"
    end

    context "with text" do
      pending "renders"
    end

    context "with neither block nor text" do
      pending "raises ArgumentError"
    end
  end

  describe "#caption" do
    context "with author" do
      pending "renders"
    end

    context "with author and cite" do
      pending "renders"
    end
  end

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
      expected = "article published standalone"
      actual   = helper.combine_classes(" article ", "published", " ", nil, ["article", "\n\nstandalone  "])

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

  describe "#date_tag" do
    it "formats dates consistently" do
      Timecop.freeze(2050, 3, 3) do
        expect(helper.date_tag(Time.zone.now)).to eq(
          '<time datetime="2050-03-03T00:00:00-08:00">03/03/2050 at 12:00AM</time>'
        )
      end
    end
  end

  describe "#paragraphs" do
    specify do
      str      = "\t\n  \n   one\n\ntwo\t\t\n\nthree    things\n \n\n"
      expected = "<p>one</p>\n<p>two</p>\n<p>three things</p>"
      actual   = helper.paragraphs(str)

      expect(actual).to eq(expected)
    end
  end

  describe "#smart_truncate" do
    subject { helper.smart_truncate(title, opts) }

    let(:title) { "If I only could, I'd make a deal with God." }

    describe "no length specified" do
      let(:opts) { {} }

      it { is_expected.to eq(title) }
    end

    describe "shorter than length" do
      let(:opts) { { length: 50 } }

      it { is_expected.to eq(title) }
    end

    describe "longer than length" do
      let(:opts) { { length: 20 } }

      it { is_expected.to eq("If I only could,…") }
    end
  end
end
