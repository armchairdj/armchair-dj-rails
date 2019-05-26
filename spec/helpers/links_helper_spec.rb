# frozen_string_literal: true

require "rails_helper"

RSpec.describe LinksHelper do
  describe "#link_list" do
    subject { helper.link_list(links, opts) }

    let(:opts) { {} }

    context "empty collection" do
      let(:links) { Link.none }

      it { is_expected.to eq(nil) }
    end

    context "full collection" do
      let(:links) { Link.where(id: ids_for_minimal_list(3)) }

      it "has the correct markup" do
        is_expected.to have_tag("ul", count: 1)
        is_expected.to have_tag("ul li", count: 3)
        is_expected.to have_tag("ul li a", count: 3)
      end

      it "has the correct urls and text" do
        is_expected.to have_tag("ul li a[href='#{links[0].url}']", text: links[0].description)
        is_expected.to have_tag("ul li a[href='#{links[1].url}']", text: links[1].description)
        is_expected.to have_tag("ul li a[href='#{links[2].url}']", text: links[2].description)
      end

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("ul.foo#bar", count: 1) }
      end
    end
  end
end
