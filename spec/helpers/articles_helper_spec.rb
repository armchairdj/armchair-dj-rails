# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticlesHelper do
  let(:instance) { create(:minimal_article, title: "This Is the Title") }

  describe "#article_title" do
    describe "untruncated" do
      subject { helper.article_title(instance) }

      it { is_expected.to eq("This Is the Title") }
    end

    describe "truncated" do
      subject { helper.article_title(instance, length: 15) }

      it { is_expected.to eq("This Is the…") }
    end
  end

  describe "#link_to_article" do
    describe "published" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(true)
      end

      describe "public" do
        subject { helper.link_to_article(instance, class: "test") }

        it "has the correct markup" do
          is_expected.to have_tag(
            "a[href='/articles/#{instance.slug}'][class='test']",
            text:  "This Is the Title",
            count: 1
          )
        end
      end

      describe "truncated" do
        subject { helper.link_to_article(instance, length: 15, class: "test") }

        it "has the correct markup" do
          is_expected.to have_tag(
            "a[href='/articles/#{instance.slug}'][class='test']",
            text:  "This Is the…",
            count: 1
          )
        end
      end

      describe "admin" do
        subject { helper.link_to_article(instance, admin: true) }

        it "has the correct markup" do
          is_expected.to have_tag(
            "a[href='/admin/articles/#{instance.to_param}']",
            text:  "This Is the Title",
            count: 1
          )
        end
      end
    end

    describe "unpublished" do
      before(:each) do
        allow(instance).to receive(:published?).and_return(false)
      end

      describe "public" do
        subject { helper.link_to_article(instance) }

        it { is_expected.to eq(nil) }
      end

      describe "admin" do
        subject { helper.link_to_article(instance, admin: true) }

        it "has the correct markup" do
          is_expected.to have_tag(
            "a[href='/admin/articles/#{instance.to_param}']",
            text:  "This Is the Title",
            count: 1
          )
        end
      end
    end
  end

  pending "#uri_for_article"
end
