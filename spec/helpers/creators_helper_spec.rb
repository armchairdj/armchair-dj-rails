# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorsHelper, type: :helper do
  describe "#link_to_creator" do
    let(:instance) { create(:minimal_creator, name: "Kate Bush") }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_creator(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/creators/#{instance.slug}'][class='test']",
          text:  "Kate Bush",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_creator(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/creators/#{instance.to_param}']",
          text:  "Kate Bush",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_creator(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_creator(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/creators/#{instance.to_param}']",
          text:  "Kate Bush",
          count: 1
        ) }
      end
    end
  end
end
