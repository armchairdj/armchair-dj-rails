# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsHelper do
  describe "link methods" do
    pending "#link_to_post"

    pending "#url_for_post"
  end

  describe "display methods" do
    pending "#post_title"

    pending "#post_body"

    describe "#post_published_date" do
      let(:draft) { create(:minimal_article, :draft) }
      let(:scheduled) { create(:minimal_article, :scheduled) }
      let(:published) { create(:minimal_article, :published) }

      specify do
        Timecop.freeze(2050, 3, 3) do
          expect(helper.post_published_date(published)).to eq(
            '<time datetime="2050-03-03T00:00:00-08:00" pubdate="pubdate">03/03/2050 at 12:00AM</time>'
          )
        end
      end

      specify { expect(helper.post_published_date(draft)).to eq(nil) }
      specify { expect(helper.post_published_date(scheduled)).to eq(nil) }
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

      specify "calls #post_status_icon" do
        expect(helper.post_status_icon(create(:minimal_mixtape, :scheduled))).to eq(
          '<span class="svg-icon post-scheduled">clock</span>'
        )
      end

      specify "calls #post_status_icon" do
        expect(helper.post_status_icon(create(:minimal_review, :published))).to eq(
          '<span class="svg-icon post-published">unlocked</span>'
        )
      end
    end
  end
end
