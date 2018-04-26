require "rails_helper"

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

      actual = helper.non_semantic_svg_image("image_path")

      expect(actual).to be_a_kind_of(String)
    end

    it "generates non-svg with partial aria attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      false,
        class:     "scalable-image"
      })

      actual = helper.non_semantic_svg_image("image_path", title: "title")

      expect(actual).to be_a_kind_of(String)
    end

    it "generates aria svg with optional aria attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      true,
        class:     "scalable-image",
        title:     "title",
        desc:      "desc"
      })

      actual = helper.non_semantic_svg_image("image_path", title: "title", desc: "desc")

      expect(actual).to be_a_kind_of(String)
    end

    it "accepts extra html attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment:         true,
        aria:              false,
        class:             "scalable-image author",
        "data-controller": "svg"
      })

      actual = helper.non_semantic_svg_image("image_path", title: "title", "data-controller": "svg", class: "author")

      expect(actual).to be_a_kind_of(String)
    end
  end

  describe "#semantic_svg_image" do
    it "errors without both aria attributes" do
      expect(helper).to_not receive(:inline_svg)

      expect {
        helper.semantic_svg_image("image_path", title: "title")
      }.to raise_exception(ArgumentError)
    end


    it "generates aria svg" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment: true,
        aria:      true,
        class:     "scalable-image",
        title:     "title",
        desc:      "desc"
      })

      actual = helper.semantic_svg_image("image_path", title: "title", desc: "desc")

      expect(actual).to be_a_kind_of(String)
    end

    it "accepts extra html attributes" do
      expect(helper).to receive(:inline_svg).with("image_path", {
        nocomment:         true,
        aria:              true,
        class:             "scalable-image author",
        title:             "title",
        desc:              "desc",
        "data-controller": "svg"
      })

      actual = helper.semantic_svg_image("image_path", title: "title", desc: "desc", "data-controller": "svg", class: "author")

      expect(actual).to be_a_kind_of(String)
    end
  end

  describe "#svg_icon" do
    before(:each) do
       allow(helper).to receive(:semantic_svg_image).and_call_original
      expect(helper).to receive(:semantic_svg_image).with("path", title: "title", desc: "desc").and_call_original
    end

    it "wraps a semantic svg" do
      expected = '<span class="svg-icon">inlined_svg</span>'
      actual   = helper.svg_icon("path", title: "title", desc: "desc")

      expect(actual).to eq(expected)
    end

    it "allows html_opts for wrapper_class" do
      expected = '<span class="svg-icon post-published">inlined_svg</span>'
      actual   = helper.svg_icon("path", title: "title", desc: "desc", wrapper_class: "post-published")

      expect(actual).to eq(expected)
    end
  end
end
