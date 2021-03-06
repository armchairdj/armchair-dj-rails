# frozen_string_literal: true

require "rails_helper"

RSpec.describe UsersHelper do
  include MarkupHelper

  describe "#link_to_author_of" do
    subject { link_to_author_of(obj, opts) }

    let(:author) { create(:writer, username: "ArmchairDJ") }
    let(:obj) { double }
    let(:opts) { {} }

    before { allow(obj).to receive(:author).and_return(author) }

    describe "published" do
      before { allow(author).to receive(:published?).and_return(true) }

      it "has the correct layout" do
        is_expected.to have_tag("address.author", count: 1) do
          with_tag("a[rel='author'][href='/profile/ArmchairDJ']", text: "ArmchairDJ", count: 1)
        end
      end

      context "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("address.author.foo#bar", count: 1) }
      end

      describe "admin" do
        let(:opts) { { admin: true } }

        it "has the correct markup" do
          is_expected.to have_tag("address.author", count: 1) {
            with_tag("a[rel='author'][href='/admin/users/ArmchairDJ']", text: "ArmchairDJ", count: 1)
          }
        end
      end
    end

    describe "unpublished" do
      before { allow(author).to receive(:published?).and_return(false) }

      it { is_expected.to eq(nil) }
    end
  end

  describe "#link_to_user" do
    subject { helper.link_to_user(user, opts) }

    let(:user) { create(:writer, username: "ArmchairDJ") }
    let(:opts) { {} }

    describe "published" do
      before do
        create(:minimal_review, :published, author: user)
        user.reload
      end

      describe "public" do
        it "has the correct markup" do
          is_expected.to have_tag("a[href='/profile/ArmchairDJ']", text: "ArmchairDJ", count: 1)
        end
      end

      describe "admin" do
        let(:opts) { { admin: true } }

        it { is_expected.to have_tag("a[href='/admin/users/ArmchairDJ']", text: "ArmchairDJ", count: 1) }
      end

      context "with options" do
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

        it "has the correct markup" do
          is_expected.to have_tag("a[href='/admin/users/ArmchairDJ']", text: "ArmchairDJ", count: 1)
        end
      end
    end
  end

  pending "#url_for_user"
end
