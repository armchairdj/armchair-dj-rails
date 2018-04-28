# frozen_string_literal: true

require "rails_helper"

RSpec.describe LayoutHelper, type: :helper do
  describe "#body_classes" do
    it "works on non-admin pages" do
      assign(:admin, false)

      expect(helper.body_classes).to eq("public")
    end

    it "works on admin pages" do
      assign(:admin, true)

      expect(helper.body_classes).to eq("admin")
    end
  end

  describe "#copyright_notice" do
    it "goes to current year" do
      Timecop.freeze(2050, 3, 3) do
        expect(helper.copyright_notice).to eq("&copy; 1996-2050 #{t("site.owner")}")
      end
    end

    it "can omit html entities" do
      Timecop.freeze(2050, 3, 3) do
        expect(helper.copyright_notice(english: true)).to eq("Copyright 1996-2050 #{t("site.owner")}")
      end
    end
  end

  describe "#join_attr" do
    it "combines a nested array of strings into a single sorted, deduped html attribute" do
      expected = "1 dude is pretty snazzy"
      actual   = helper.join_attr([
        "snazzy",
        [" pretty "],
        "",
        [[[nil, "dude     \t\nis"]]],
        " ",
        1,
        nil,
        "pretty\f",
        "snazzy\t\tis"
      ])

      expect(actual).to eq(expected)
    end

    it "returns nil" do
      expect(helper.join_attr("", " ", nil)).to eq(nil)
    end
  end

  describe "#page_container_classes" do
    it "works with one class" do
      assign(:page_container_class, "foo")

      expect(helper.page_container_classes).to eq("foo")
    end

    it "works with array multiple classes" do
      assign(:page_container_class, ["foo", "bar"])

      expect(helper.page_container_classes).to eq("bar foo")
    end

    it "works with string of multiple classes" do
      assign(:page_container_class, "foo bar")

      expect(helper.page_container_classes).to eq("bar foo")
    end

    it "works with no classes" do
      assign(:page_container_class, nil)

      expect(helper.page_container_classes).to eq(nil)
    end
  end

  describe "#page_container_tag" do
    it "uses instance variable" do
      assign(:page_container, :div)

      expect(helper.page_container_tag).to eq(:div)
    end

    it "uses default" do
      assign(:page_container, nil)

      expect(helper.page_container_tag).to eq(:article)
    end
  end

  describe "#page_title" do
    it "uses string instance variable" do
      assign(:title, "Kate Bush: Hounds of Love")

      expect(helper.page_title).to eq("#{t("site.name")} | Kate Bush: Hounds of Love")
    end

    it "uses array instance variable" do
      assign(:title, ["Kate Bush", "Hounds of Love"])

      expect(helper.page_title).to eq("#{t("site.name")} | Kate Bush | Hounds of Love")
    end

    it "raises without instance variable" do
      expect {
        helper.page_title
      }.to raise_exception(NoMethodError)
    end

    it "uses default on homepage" do
      assign(:homepage, true)

      expect(helper.page_title).to eq(t("site.name_with_tagline"))
    end

    it "ignores instance variable on homepage" do
      assign(:homepage, true)
      assign(:title, "won't be used")

      expect(helper.page_title).to eq(t("site.name_with_tagline"))
    end
  end

  describe "#wrapper_classes" do
    it "works on non-admin pages" do
      assign(:admin, false)

      expect(helper.wrapper_classes).to eq("public wrapper")
    end

    it "works on admin pages" do
      assign(:admin, true)

      expect(helper.wrapper_classes).to eq("admin wrapper")
    end
  end

  describe "#site_logo" do
    specify { expect(helper.site_logo).to match('<img class="chair" alt="Armchair DJ logo" src="/assets/armchair-.*.jpg" />') }
  end
end
