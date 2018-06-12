# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksHelper, type: :helper do
  describe "#link_to_work" do
    let(:instance) { create(:minimal_book, title: "Vacuum Flowers", credits_attributes: {
      "0" => { creator_id: create(:minimal_creator, name: "Michael Swanwick").id }
    }) }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_work(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/works/#{instance.slug}'][class='test']",
          text:  "Michael Swanwick: Vacuum Flowers",
          count: 1
        ) }
      end

      context "full: false" do
        subject { helper.link_to_work(instance, full: false) }

        it { is_expected.to have_tag("a[href='/works/#{instance.slug}']",
          text:  "Vacuum Flowers",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_work(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/works/#{instance.to_param}']",
          text:  "Michael Swanwick: Vacuum Flowers",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_work(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_work(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/works/#{instance.to_param}']",
          text:  "Michael Swanwick: Vacuum Flowers",
          count: 1
        ) }
      end
    end
  end
end
