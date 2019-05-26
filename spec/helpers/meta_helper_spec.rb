# frozen_string_literal: true

require "rails_helper"

RSpec.describe MetaHelper do
  describe "#head_tags" do
    before(:each) do
      allow(helper).to receive(  :csrf_meta_tags).and_return("csrf")
      allow(helper).to receive(:content_type_tag).and_return("content_type")
      allow(helper).to receive( :description_tag).and_return("description")
      allow(helper).to receive(  :turbolinks_tag).and_return("turbolinks")
      allow(helper).to receive(    :viewport_tag).and_return("viewport")
      allow(helper).to receive(  :apple_icon_tag).and_return("apple_icon")
      allow(helper).to receive(     :favicon_tag).and_return("favicon")
      allow(helper).to receive(    :shortcut_tag).and_return("shortcut")
      allow(helper).to receive(         :rss_tag).and_return("rss")
    end

    it "outputs tags for html head" do
      expect(helper.head_tags).to eq([
        "csrf",
        "content_type",
        "description",
        "turbolinks",
        "viewport",
        "apple_icon",
        "favicon",
        "shortcut",
        "rss"
      ].join("\n"))
    end

    it "ignores blank tags" do
      allow(helper).to receive(:description_tag).and_return(nil)

      expect(helper.head_tags).to eq([
        "csrf",
        "content_type",
        "turbolinks",
        "viewport",
        "apple_icon",
        "favicon",
        "shortcut",
        "rss"
      ].join("\n"))
    end
  end

  describe "meta tags" do
    describe "#meta_tag" do
      it "outputs the tag" do
        expect(helper.meta_tag("key", "value")).to eq('<meta name="key" content="value" />')
      end

      it "overrides the name key" do
        expect(helper.meta_tag("key", "value", name_key: "http-equiv")).to eq('<meta http-equiv="key" content="value" />')
      end

      it "nils without content" do
        expect(helper.meta_tag("key", nil)).to eq(nil)
      end

      it "removes quotation marks" do
        expect(helper.meta_tag("description", '"Foo", "Bar"')).to eq('<meta name="description" content="Foo, Bar" />')
      end
    end

    describe "#content_type_tag" do
      it "outputs the tag" do
        expect(helper.content_type_tag).to eq('<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />')
      end
    end

    describe "#description_tag" do
      it "outputs the tag" do
        assign(:meta_description, "description")

        expect(helper.description_tag).to eq('<meta name="description" content="description" />')
      end

      it "nils if no description" do
        expect(helper.description_tag).to eq(nil)
      end
    end

    describe "#turbolinks_tag" do
      it "outputs the tag" do
        expect(helper.turbolinks_tag).to eq('<meta name="turbolinks-cache-control" content="no-preview" />')
      end
    end

    describe "#viewport_tag" do
      it "outputs the tag" do
        expect(helper.viewport_tag).to eq('<meta name="viewport" content="width = device-width, initial-scale = 1.0" />')
      end
    end
  end

  describe "icons and links" do
    describe "#apple_icon_tag" do
      it "outputs the tag" do
        expect(helper.apple_icon_tag).to match('<link rel="apple-touch-icon" href="http://test.host/assets/apple-touch-icon-.*.png" />')
      end
    end

    describe "#favicon_tag" do
      it "outputs the tag" do
        expect(helper.favicon_tag).to eq('<link rel="icon" sizes="192x192" href="/favicon.ico" />')
      end
    end

    describe "#rss_tag" do
      it "outputs the tag" do
        expect(helper.rss_tag).to match('<link rel="alternate" type="application/rss+xml" title="RSS" href="http://test.armchair-dj.com/feed.rss" />')
      end
    end

    describe "#shortcut_tag" do
      it "outputs the tag" do
        expect(helper.shortcut_tag).to eq('<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />')
      end
    end
  end
end
