# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesHelper do
  let(:playlist) { create(:minimal_playlist, title: "This Is the Title") }
  let(:instance) { create(:minimal_mixtape, playlist: playlist) }

  describe "#mixtape_title" do
    describe "untruncated" do
      subject { helper.mixtape_title(instance) }

      it { is_expected.to eq("This Is the Title") }
    end

    describe "truncated" do
      subject { helper.mixtape_title(instance, length: 15) }

      it { is_expected.to eq("This Is the…") }
    end
  end

  describe "#link_to_mixtape" do
    describe "published" do
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
          text:  "This Is the…",
          count: 1
        ) }
      end

      describe "admin" do
        subject { helper.link_to_mixtape(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/mixtapes/#{instance.to_param}']",
          text:  "This Is the Title",
          count: 1
        ) }
      end
    end

    describe "unpublished" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(false)
      end

      describe "public" do
        subject { helper.link_to_mixtape(instance) }

        it { is_expected.to eq(nil) }
      end

      describe "admin" do
        subject { helper.link_to_mixtape(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/mixtapes/#{instance.to_param}']",
          text:  "This Is the Title",
          count: 1
        ) }
      end
    end
  end

  pending "#url_for_mixtape"
end
