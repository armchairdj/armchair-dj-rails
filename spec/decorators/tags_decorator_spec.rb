# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsDecorator do
  include Draper::ViewHelpers

  describe "#list" do
    before(:each) do
      allow(helpers).to receive(:admin_tag_path).and_return("/admin_tag_path")
    end

    subject { tags.decorate.list(opts) }

    let( :opts) { {} }

    context "empty collection" do
      let(:tags) { Tag.none }

      it { is_expected.to eq(nil) }
    end

    context "full collection" do
      let(:tags) { Tag.where(id: 3.times.map { |i| create(:minimal_tag).id }) }

      it { is_expected.to_not have_tag("a") }

      it { is_expected.to have_tag("ul", count: 1) }
      it { is_expected.to have_tag("ul li", count: 3) }

      it { is_expected.to have_tag("ul li", text: tags[0].name) }
      it { is_expected.to have_tag("ul li", text: tags[1].name) }
      it { is_expected.to have_tag("ul li", text: tags[2].name) }

      context "admin: true" do
        let(:opts) { { admin: true } }

        it { is_expected.to have_tag("ul", count: 1) }
        it { is_expected.to have_tag("ul li", count: 3) }
        it { is_expected.to have_tag("ul li a",  count: 3) }

        it { is_expected.to have_tag('ul li a[href="/admin_tag_path"]', text: tags[0].name) }
        it { is_expected.to have_tag('ul li a[href="/admin_tag_path"]', text: tags[1].name) }
        it { is_expected.to have_tag('ul li a[href="/admin_tag_path"]', text: tags[2].name) }
      end

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("ul.foo#bar", count: 1) }
      end
    end
  end
end
