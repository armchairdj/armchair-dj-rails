# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapesHelper, type: :helper do
  let(    :work) { create(:kate_bush_hounds_of_love, subtitle: "Alternative Version") }
  let(:instance) { create(:minimal_review, work: work) }

  describe "#review_title" do
    describe "untruncated" do
      subject { helper.review_title(instance) }

      it { is_expected.to eq("Kate Bush: Hounds of Love: Alternative Version") }
    end

    describe "truncated" do
      subject { helper.review_title(instance, length: 15) }

      it { is_expected.to eq("Kate Bush: Hou…") }
    end

    describe "full: false" do
      subject { helper.review_title(instance, full: false) }

      it { is_expected.to eq("Hounds of Love: Alternative Version") }
    end
  end

  describe "#link_to_review" do
    context "published" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
      end

      describe "public" do
        subject { helper.link_to_review(instance, class: "test") }

        it { is_expected.to have_tag("a[href='/reviews/#{instance.slug}'][class='test']",
          text:  "Kate Bush: Hounds of Love: Alternative Version",
          count: 1
        ) }
      end

      describe "truncated" do
        subject { helper.link_to_review(instance, length: 15, class: "test") }

        it { is_expected.to have_tag("a[href='/reviews/#{instance.slug}'][class='test']",
          text:  "Kate Bush: Hou…",
          count: 1
        ) }
      end

      describe "full: false" do
        subject { helper.link_to_review(instance, full: false) }

        it { is_expected.to have_tag("a[href='/reviews/#{instance.slug}']",
          text:  "Hounds of Love: Alternative Version",
          count: 1
        ) }
      end

      context "admin" do
        subject { helper.link_to_review(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/reviews/#{instance.id}']",
          text:  "Kate Bush: Hounds of Love: Alternative Version",
          count: 1
        ) }
      end
    end

    context "unpublished" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(false)
      end

      context "public" do
        subject { helper.link_to_review(instance) }

        it { is_expected.to eq(nil) }
      end

      context "admin" do
        subject { helper.link_to_review(instance, admin: true) }

        it { is_expected.to have_tag("a[href='/admin/reviews/#{instance.id}']",
          text:  "Kate Bush: Hounds of Love: Alternative Version",
          count: 1
        ) }
      end
    end
  end
end
