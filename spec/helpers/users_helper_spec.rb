# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper, type: :helper do
  describe "#link_to_user" do
    let(:instance) { create(:minimal_user, username: "ArmchairDJ") }

    context "viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(true)
      end

      context "public" do
        subject { helper.link_to_user(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/profile/ArmchairDJ'][class='test']",
          text:  "ArmchairDJ",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_user(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/users/#{instance.to_param}']",
          text:  "ArmchairDJ",
          count: 1
        ) }
      end
    end

    context "non-viewable" do
      before(:each) do
        allow(instance).to receive(:viewable?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_user(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_user(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/users/#{instance.to_param}']",
          text:  "ArmchairDJ",
          count: 1
        ) }
      end
    end
  end
end
