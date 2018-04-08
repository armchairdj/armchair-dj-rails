require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  let(:standalone_post      ) { create(:standalone_post, title: "Standalone") }
  let(:hounds_of_love_review) { create(:hounds_of_love_album_review) }

  describe "#link_to_post" do
    it "uses title for standalone" do
      actual = helper.link_to_post(standalone_post)

      expect(actual).to have_tag('a[href^="/posts/"]',
        text:  "Standalone",
        count: 1
      )
    end

    it "by default uses work title for review" do
      actual = helper.link_to_post(hounds_of_love_review)

      expect(actual).to have_tag('a[href^="/posts/"]',
        text:  "Hounds of Love",
        count: 1
      )
    end

    it "can use creator name and work title for review" do
      actual = helper.link_to_post(hounds_of_love_review, full: true)

      expect(actual).to have_tag('a[href^="/posts/"]',
        text:  "Kate Bush: Hounds of Love",
        count: 1
      )
    end
  end

  describe "#post_type" do
    specify{ expect(helper.post_type(standalone_post      )).to eq("standalone"  ) }
    specify{ expect(helper.post_type(hounds_of_love_review)).to eq("album review") }
  end
end
