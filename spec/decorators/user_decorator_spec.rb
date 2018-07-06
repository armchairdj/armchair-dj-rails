# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserDecorator do
  include Draper::ViewHelpers

  describe "#link" do
    subject { user.decorate.link(opts) }

    let(:user) { create(:writer, username: "ArmchairDJ") }

    let(:opts) { {} }

    describe "published" do
      before(:each) { create(:minimal_review, :published, author: user); user.reload }

      describe "public" do
        it { is_expected.to have_tag("a[href='/profile/ArmchairDJ']", text:  "ArmchairDJ", count: 1) }
      end

      describe "admin" do
        let(:opts) { { admin: true } }

        it { is_expected.to have_tag("a[href='/admin/users/ArmchairDJ']", text:  "ArmchairDJ", count: 1) }
      end

      describe "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("a.foo#bar", count: 1) }
      end
    end

    describe "unpublished" do
      describe "public" do
        it { is_expected.to eq(nil) }
      end

      describe "admin" do
        let(:opts) { { admin: true } }

        it { is_expected.to have_tag("a[href='/admin/users/ArmchairDJ']", text:  "ArmchairDJ", count: 1) }
      end
    end
  end
end
