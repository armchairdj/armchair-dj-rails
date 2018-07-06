# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagDecorator do
  include Draper::ViewHelpers

  describe "#link" do
    before(:each) { allow(helpers).to receive(:admin_tag_path).and_return("/admin_tag_path") }

    subject { tag.link(opts) }

    let(:opts) { {} }

    describe "default" do
      let(:tag) { create(:minimal_tag, name: "Tag").decorate }

      it { is_expected.to have_tag('a[href="/admin_tag_path"]', text: "Tag", count: 1) }
    end
  end
end
