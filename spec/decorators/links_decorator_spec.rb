# frozen_string_literal: true

require "rails_helper"

RSpec.describe LinksDecorator do
  include Draper::ViewHelpers

  describe "#list" do
    subject { links.decorate.list(opts) }

    let(:opts) { {} }

    context "empty collection" do
      let(:links) { Link.none }

      it { is_expected.to eq(nil) }
    end

    context "full collection" do
      let(:links) { Link.where(id: 3.times.map { |i| create(:minimal_link).id }) }

      it { is_expected.to have_tag("ul", count: 1) }
      it { is_expected.to have_tag("ul li", count: 3) }
      it { is_expected.to have_tag("ul li a",  count: 3) }

      it { is_expected.to have_tag("ul li a[href='#{links[0].url}']", text: links[0].description) }
      it { is_expected.to have_tag("ul li a[href='#{links[1].url}']", text: links[1].description) }
      it { is_expected.to have_tag("ul li a[href='#{links[2].url}']", text: links[2].description) }

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("ul.foo#bar", count: 1) }
      end
    end
  end
end
