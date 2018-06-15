# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsHelper, type: :helper do
  describe "#link_to_tag" do
    let(:instance) { create(:minimal_tag, name: "Tag") }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_tag(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/tags/#{instance.to_param}'][class='test']",
          text:  "Tag",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_tag(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/tags/#{instance.to_param}']",
          text:  "Tag",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_tag(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_tag(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/tags/#{instance.to_param}']",
          text:  "Tag",
          count: 1
        ) }
      end
    end
  end
end
