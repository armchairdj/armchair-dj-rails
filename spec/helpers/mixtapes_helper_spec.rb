# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesHelper, type: :helper do
  let(:playlist) { create(:minimal_playlist, title: "This Is the Title") }
  let(:instance) { create(:minimal_mixtape, playlist: playlist) }

  describe "#mixtape_title" do
    describe "untruncated" do
      subject { helper.mixtape_title(instance) }

      it { is_expected.to eq("This Is the Title") }
    end

    describe "truncated" do
      subject { helper.mixtape_title(instance, length: 15) }

      it { is_expected.to eq("This Is the Ti…") }
    end
  end

  describe "#link_to_mixtape" do
    context "published" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
      end

      describe "public" do
        subject { helper.link_to_mixtape(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/mixtapes/#{instance.slug}'][class='test']",
          text:  "This Is the Title",
          count: 1
        ) }
      end

      describe "truncated" do
        subject { helper.link_to_mixtape(instance, length: 15, class: "test") }

        it { is_expected.to have_tag("a[href='/mixtapes/#{instance.slug}'][class='test']",
          text:  "This Is the Ti…",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_mixtape(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/mixtapes/#{instance.id}']",
          text:  "This Is the Title",
          count: 1
        ) }
      end
    end

    context "unpublished" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_mixtape(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_mixtape(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/mixtapes/#{instance.id}']",
          text:  "This Is the Title",
          count: 1
        ) }
      end
    end
  end
end
