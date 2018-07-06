# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagDecorator do
  include Draper::ViewHelpers

  describe "#link" do
    before(:each) do
      allow(helpers).to receive(:admin_tag_path).and_return("/admin_tag_path")
    end

    subject { tag.decorate.link(opts) }

    let(:opts) { {} }

    describe "default" do
      let(:tag) { create(:minimal_tag, name: "Tag") }

      it { is_expected.to have_tag('a[href="/admin_tag_path"]', text: "Tag", count: 1) }

      describe "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("a.foo#bar", count: 1) }
      end
    end
  end
end
