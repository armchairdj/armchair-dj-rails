# frozen_string_literal: true

require "ffaker"
require "rails_helper"

RSpec.describe StyleGuidesHelper do
  describe "#lorem_html_paragraphs" do
    before(:each) do
      allow(FFaker::HipsterIpsum).to receive(:paragraphs).with(2).and_return(["first", "second"])
      allow(FFaker::HipsterIpsum).to receive(:paragraphs).with(3).and_return(["first", "second", "third"])
    end

    it "gives 2 paragraphs by default" do
      expected = "<p>first</p>\n<p>second</p>"
      actual   = helper.lorem_html_paragraphs

      expect(actual).to eq(expected)
    end

    it "gives arbitrary paragraphs" do
      expected = "<p>first</p>\n<p>second</p>\n<p>third</p>"
      actual   = helper.lorem_html_paragraphs(3)

      expect(actual).to eq(expected)
    end
  end
end
