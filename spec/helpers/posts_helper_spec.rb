# frozen_string_literal: true

require "rails_helper"

include UsersHelper

RSpec.describe PostsHelper, type: :helper do
  describe "display methods" do
    describe "#formatted_post_body" do
      subject { create(:minimal_article) }

      it "creates paragraphs" do
        expected = "<p>one</p>\n<p>two</p>"

         allow(helper).to receive(:paragraphs).and_return(expected)
        expect(helper).to receive(:paragraphs).with(subject.body)

        expect(helper.formatted_post_body(subject)).to eq(expected)
      end
    end

    describe "#post_published_date" do
      let(:draft    ) { create(:minimal_article, :draft    ) }
      let(:scheduled) { create(:minimal_article, :scheduled) }
      let(:published) { create(:minimal_article, :published) }

      specify do
        Timecop.freeze(2050, 3, 3) do
          expect(helper.post_published_date(published)).to eq(
            '<time datetime="2050-03-03T00:00:00Z" pubdate="pubdate">03/03/2050 at 12:00AM</time>'
          )
        end
      end

      specify { expect(helper.post_published_date(draft    )).to eq(nil) }
      specify { expect(helper.post_published_date(scheduled)).to eq(nil) }
    end

    describe "#post_scheduled_date" do
      let!(:draft    ) { create(:minimal_article, :draft    ) }
      let!(:scheduled) { create(:minimal_article, :scheduled) }
      let!(:published) { create(:minimal_article, :published) }

      specify do
        Timecop.freeze(2050, 3, 3) do
          scheduled.update_column(:publish_on, 3.weeks.from_now)

          expect(helper.post_scheduled_date(scheduled)).to eq(
            '<time datetime="2050-03-24T00:00:00Z">03/24/2050 at 12:00AM</time>'
          )
        end
      end

      specify { expect(helper.post_scheduled_date(draft    )).to eq(nil) }
      specify { expect(helper.post_scheduled_date(published)).to eq(nil) }
    end

    describe "#truncated_title" do
      let(:title) { "abcdefghijklmnopqrstuvwxyz" }

      describe "will truncate" do
        subject { helper.truncated_title(title, length: 20) }

        it { is_expected.to eq("abcdefghijklmnopqrs…") }
      end

      describe "will truncate but too short" do
        subject { helper.truncated_title(title, length: 30) }

        it { is_expected.to eq(title) }
      end

      describe "will not truncate" do
        subject { helper.truncated_title(title) }

        it { is_expected.to eq(title) }
      end
    end
  end

  describe "icon methods" do
    describe "#post_status_icon" do
      before(:each) do
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/lock-locked.svg",   anything).and_return("locked")
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/lock-unlocked.svg", anything).and_return("unlocked")
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/clock.svg",         anything).and_return("clock")
      end

      specify "calls #post_draft_icon" do
        expect(helper.post_status_icon(create(:minimal_article, :draft))).to eq(
          '<span class="svg-icon post-draft">locked</span>'
        )
      end

      specify "calls #article_scheduled_icon" do
        expect(helper.post_status_icon(create(:minimal_mixtape, :scheduled))).to eq(
          '<span class="svg-icon post-scheduled">clock</span>'
        )
      end

      specify "calls #article_published_icon" do
        expect(helper.post_status_icon(create(:minimal_review, :published))).to eq(
          '<span class="svg-icon post-published">unlocked</span>'
        )
      end
    end
  end

  describe "link methods" do
    describe "#link_to_post_author" do
      let(:author) { create(:writer, username: "armchairdj") }

      subject { link_to_post_author(instance) }

      describe "published" do
        let(:instance) { create(:minimal_article, :published, author: author) }

        it { is_expected.to eq('<address class="author"><a rel="author" href="/profile/armchairdj">armchairdj</a></address>') }
      end

      describe "scheduled" do
        let(:instance) { create(:minimal_article, :scheduled, author: author) }

        it { is_expected.to eq(nil) }
      end

      describe "draft" do
        let(:instance) { create(:minimal_article, :draft, author: author) }

        it { is_expected.to eq(nil) }
      end
    end
  end
end
