# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsHelper, type: :helper do
  context "display methods" do
    describe "#formatted_post_body" do
      subject { create(:minimal_post) }

      it "creates paragraphs" do
        expected = "<p>one</p>\n<p>two</p>"

         allow(helper).to receive(:paragraphs).and_return(expected)
        expect(helper).to receive(:paragraphs).with(subject.body)

        expect(helper.formatted_post_body(subject)).to eq(expected)
      end
    end

    describe "#post_published_date" do
      let(:draft    ) { create(:minimal_post, :draft    ) }
      let(:scheduled) { create(:minimal_post, :scheduled) }
      let(:published) { create(:minimal_post, :published) }

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
      let!(:draft    ) { create(:minimal_post, :draft    ) }
      let!(:scheduled) { create(:minimal_post, :scheduled) }
      let!(:published) { create(:minimal_post, :published) }

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

    describe "#post_title" do
      let(:minimal_post      ) { create(:minimal_post, title: "Standalone") }
      let(:hounds_of_love_review) { create(:hounds_of_love_album_review) }
      let(:subtitled_review     ) { create(:junior_boys_remix_review) }

      context "default" do
        it "uses title for standalone" do
          expect(helper.post_title(minimal_post)).to eq("Standalone")
        end

        it "uses creator and title for review" do
          expect(helper.post_title(hounds_of_love_review)).to eq("Kate Bush: Hounds of Love")
        end

        it "uses subtitle when available" do
          expect(helper.post_title(subtitled_review)).to eq("Junior Boys: Like a Child: C2 Remix")
        end
      end

      context "full: false" do
        it "skips creator" do
          expect(helper.post_title(hounds_of_love_review, full: false)).to eq("Hounds of Love")
        end

        it "still includes subtitle" do
          expect(helper.post_title(subtitled_review, full: false)).to eq("Like a Child: C2 Remix")
        end
      end
    end
  end

  context "icon methods" do
    describe "#post_status_icon" do
      before(:each) do
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/lock-locked.svg",   anything).and_return("locked")
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/lock-unlocked.svg", anything).and_return("unlocked")
        allow(helper).to receive(:semantic_svg_image).with("open_iconic/clock.svg",         anything).and_return("clock")
      end

      specify "calls #post_draft_icon" do
        expect(helper.post_status_icon(create(:minimal_post, :draft))).to eq(
          '<span class="svg-icon post-draft">locked</span>'
        )
      end

      specify "calls #post_scheduled_icon" do
        expect(helper.post_status_icon(create(:minimal_post, :scheduled))).to eq(
          '<span class="svg-icon post-scheduled">clock</span>'
        )
      end

      specify "calls #post_published_icon" do
        expect(helper.post_status_icon(create(:minimal_post, :published))).to eq(
          '<span class="svg-icon post-published">unlocked</span>'
        )
      end
    end
  end

  context "link methods" do
    describe "#link_to_post" do
      let(:instance) { create(:minimal_post) }

      before(:each) do
        allow(helper).to receive(:post_title).with(instance, full: true ).and_return("Long Title")
        allow(helper).to receive(:post_title).with(instance, full: false).and_return("Short Title")
      end

      context "published" do
        before(:each) do
          allow(instance).to receive(:published?).and_return(true)
        end

        context "public" do
          subject { helper.link_to_post(instance, class: "test") }

          it { is_expected.to have_tag("a[href='/posts/#{instance.slug}'][class='test']",
            text:  "Long Title",
            count: 1
          ) }
        end

        context "full: false" do
          subject { helper.link_to_post(instance, full: false) }

          it { is_expected.to have_tag("a[href='/posts/#{instance.slug}']",
            text:  "Short Title",
            count: 1
          ) }
        end

        context "admin" do
          subject { helper.link_to_post(instance, admin: true) }

          it { is_expected.to have_tag("a[href='/admin/posts/#{instance.id}']",
            text:  "Long Title",
            count: 1
          ) }
        end
      end

      context "unpublished" do
        before(:each) do
          allow(instance).to receive(:published?).and_return(false)
        end

        context "public" do
          subject { helper.link_to_post(instance) }

          it { is_expected.to eq(nil) }
        end

        context "admin" do
          subject { helper.link_to_post(instance, admin: true) }

          it { is_expected.to have_tag("a[href='/admin/posts/#{instance.id}']",
            text:  "Long Title",
            count: 1
          ) }
        end
      end
    end

    describe "#link_to_post_author" do
      subject { link_to_post_author(instance) }

      context "published" do
        let(:instance) { create(:minimal_post, :published, author: create(:writer, username: "armchairdj")) }

        it { is_expected.to eq('<address class="author"><a rel="author" href="/profile/armchairdj">armchairdj</a></address>') }
      end

      context "unpublished" do
        let(:instance) { create(:minimal_post, :draft) }

        it { is_expected.to eq(nil) }
      end
    end
  end
end
