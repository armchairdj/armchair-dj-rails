# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaHelper, type: :helper do
  describe "#link_to_medium" do
    let(:instance) { create(:minimal_medium, name: "Medium") }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_medium(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/media/#{instance.slug}'][class='test']",
          text:  "Medium",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_medium(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/media/#{instance.id}']",
          text:  "Medium",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_medium(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_medium(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/media/#{instance.id}']",
          text:  "Medium",
          count: 1
        ) }
      end
    end
  end
end
