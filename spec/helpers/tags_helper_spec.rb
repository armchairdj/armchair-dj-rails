# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsHelper do
  describe "#link_to_tag" do
    subject { helper.link_to_tag(tag, opts) }

    let(:opts) { {} }

    describe "default" do
      let(:tag) { create(:minimal_tag, name: "Tag") }

      it "has the correct markup" do
        is_expected.to have_tag("a[href='/admin/tags/#{tag.to_param}']", text: "Tag", count: 1)
      end

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it "has the correct markup" do
          is_expected.to have_tag("a.foo#bar", count: 1)
        end
      end
    end
  end

  describe "#list" do
    subject { helper.tag_list(tags, opts) }

    let(:opts) { {} }

    context "with empty collection" do
      let(:tags) { Tag.none }

      it { is_expected.to eq(nil) }
    end

    context "with full collection" do
      let(:tags) { Tag.where(id: ids_for_minimal_list(3)) }

      it { is_expected.to_not have_tag("a") }

      it "has the correct markup" do
        is_expected.to have_tag("ul", count: 1)
        is_expected.to have_tag("ul li", count: 3)

        is_expected.to have_tag("ul li", text: tags[0].name)
        is_expected.to have_tag("ul li", text: tags[1].name)
        is_expected.to have_tag("ul li", text: tags[2].name)
      end

      context "when admin is true" do
        let(:opts) { { admin: true } }

        it "has the correct markup" do
          is_expected.to have_tag("ul", count: 1)
          is_expected.to have_tag("ul li", count: 3)
          is_expected.to have_tag("ul li a", count: 3)
        end

        it "has the correct links" do
          is_expected.to have_tag("ul li a[href='/admin/tags/#{tags[0].to_param}']", text: tags[0].name)
          is_expected.to have_tag("ul li a[href='/admin/tags/#{tags[1].to_param}']", text: tags[1].name)
          is_expected.to have_tag("ul li a[href='/admin/tags/#{tags[2].to_param}']", text: tags[2].name)
        end
      end

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("ul.foo#bar", count: 1) }
      end
    end
  end
end
