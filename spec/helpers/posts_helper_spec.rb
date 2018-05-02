# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsHelper, type: :helper do
  context "display methods" do
    describe "#formatted_post_body" do
      subject { create(:standalone_post) }

      it "creates paragraphs" do
        expected = "<p>one</p>\n<p>two</p>"

         allow(helper).to receive(:paragraphs).and_return(expected)
        expect(helper).to receive(:paragraphs).with(subject.body)

        expect(helper.formatted_post_body(subject)).to eq(expected)
      end
    end

    describe "#post_published_date" do
      let(:draft    ) { create(:standalone_post, :draft    ) }
      let(:scheduled) { create(:standalone_post, :scheduled) }
      let(:published) { create(:standalone_post, :published) }

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
      let!(:draft    ) { create(:standalone_post, :draft    ) }
      let!(:scheduled) { create(:standalone_post, :scheduled) }
      let!(:published) { create(:standalone_post, :published) }

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
      let(:standalone_post      ) { create(:standalone_post, title: "Standalone") }
      let(:hounds_of_love_review) { create(:hounds_of_love_album_review) }
      let(:subtitled_review     ) { create(:junior_boys_remix_review) }

      context "default" do
        it "uses title for standalone" do
          expect(helper.post_title(standalone_post)).to eq("Standalone")
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
      context "standalone" do
        subject { build(:standalone_post, title: "Title") }

        it "nils without slug" do
          expect(helper.link_to_post(subject)).to eq(nil)
        end

        it "creates link to permalink with post title" do
          subject.save

          actual = helper.link_to_post(subject)

          expect(actual).to have_tag("a[href='/posts/#{subject.slug}']",
            text:  "Title",
            count: 1
          )
        end

        it "creates link to admin" do
          subject.save

          actual = helper.link_to_post(subject, admin: true)

          expect(actual).to have_tag("a[href='/admin/posts/#{subject.id}']",
            text:  "Title",
            count: 1
          )
        end
      end

      context "review" do
        subject { build(:review, work_id: create(:kate_bush_hounds_of_love).id) }

        it "nils without slug" do
          expect(helper.link_to_post(subject)).to eq(nil)
        end

        it "creates link to permalink with work creator and title" do
          subject.save

          actual = helper.link_to_post(subject)

          expect(actual).to have_tag("a[href='/posts/#{subject.slug}']",
            text:  "Kate Bush: Hounds of Love",
            count: 1
          )
        end

        it "creates link to permalink with work title only" do
          subject.save

          actual = helper.link_to_post(subject, full: false)

          expect(actual).to have_tag("a[href='/posts/#{subject.slug}']",
            text:  "Hounds of Love",
            count: 1
          )
        end

        it "creates link to admin" do
          subject.save

          actual = helper.link_to_post(subject, admin: true)

          expect(actual).to have_tag("a[href='/admin/posts/#{subject.id}']",
            text:  "Kate Bush: Hounds of Love",
            count: 1
          )
        end
      end
    end

    describe "#link_to_post_author" do
      subject { build(:standalone_post, author: create(:writer, username: "armchairdj")) }

      specify { expect(link_to_post_author(subject)).to match(
        '<address class="author"><a rel="author" href="/profile/armchairdj">armchairdj</a></address>'
      ) }
    end
  end
end
