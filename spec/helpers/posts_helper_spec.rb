require "rails_helper"

RSpec.describe PostsHelper, type: :helper do
  describe "#formatted_post_body" do
    it "creates paragraphs" do
      instance = create(:standalone_post, body: "  \t\n\none\n\ntwo\t\t\n\nthree    things\n\n\n")
      expected = "<p>one</p>\n<p>two</p>\n<p>three things</p>"
      actual   = helper.formatted_post_body(instance)

      expect(actual).to eq(expected)
    end
  end

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
    end

    context "review" do
      subject { build(:song_review, work_id: create(:kate_bush_hounds_of_love).id) }

      it "nils without slug" do
        expect(helper.link_to_post(subject)).to eq(nil)
      end

      it "creates link to permalink with work short title" do
        subject.save

        actual = helper.link_to_post(subject)

        expect(actual).to have_tag("a[href='/posts/#{subject.slug}']",
          text:  "Hounds of Love",
          count: 1
        )
      end

      it "creates link to permalink with work long title" do
        subject.save

        actual = helper.link_to_post(subject, full: true)

        expect(actual).to have_tag("a[href='/posts/#{subject.slug}']",
          text:  "Kate Bush: Hounds of Love",
          count: 1
        )
      end
    end
  end

  describe "#post_type" do
    specify{ expect(helper.post_type(create(:standalone_post))).to eq("Standalone Post") }
    specify{ expect(helper.post_type(create(:album_review   ))).to eq("Album Review"   ) }
  end

  describe "#post_title" do
    let(:standalone_post      ) { create(:standalone_post, title: "Standalone") }
    let(:hounds_of_love_review) { create(:hounds_of_love_album_review) }

    it "uses title for standalone" do
      expect(helper.post_title(standalone_post)).to eq("Standalone")
    end

    it "by default uses work title for review" do
      expect(helper.post_title(hounds_of_love_review)).to eq("Hounds of Love")
    end

    it "optionally includes creator for review" do
      expect(helper.post_title(hounds_of_love_review, full: true)).to eq("Kate Bush: Hounds of Love")
    end
  end
end
