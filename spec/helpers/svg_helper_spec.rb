require 'rails_helper'

RSpec.describe SvgHelper, type: :helper do
  before(:each) do
    allow(helper).to receive(:inline_svg).and_return("inlined_svg")
  end

  describe "#non_semantic_svg_image" do
    it "generates non-aria svg" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      false,
        class:     "scalable-image"
      })

      expect(helper.non_semantic_svg_image("image_path")).to be_a_kind_of(String)
    end

    it "generates non-svg with partial aria attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      false,
        class:     "scalable-image"
      })

      expect(helper.non_semantic_svg_image("image_path", title: "title")).to be_a_kind_of(String)
    end

    it "generates aria svg with optional aria attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      true,
        class:     "scalable-image",
        title:     "title",
        desc:      "desc"
      })

      expect(helper.non_semantic_svg_image("image_path", title: "title", desc: "desc")).to be_a_kind_of(String)
    end
  end

  describe "#semantic_svg_image" do
    it "generates aria svg" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      true,
        class:     "scalable-image",
        title:     "title",
        desc:      "desc"
      })

      expect(helper.semantic_svg_image("image_path", title: "title", desc: "desc")).to be_a_kind_of(String)
    end

    it "errors without both aria attributes" do
      expect(helper).to_not receive(:inline_svg)

      expect {
        helper.semantic_svg_image("image_path", title: "title")
      }.to raise_exception(ArgumentError)
    end
  end
end
