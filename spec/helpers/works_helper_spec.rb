# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksHelper, type: :helper do
  let(  :unsaved) { build(:minimal_work                      ) }
  let(    :saved) { create(:kate_bush_hounds_of_love         ) }
  let(:subtitled) { create(:junior_boys_like_a_child_c2_remix) }

  describe "#link_to_work" do
    specify { expect(helper.link_to_work(unsaved)).to eq(nil) }

    context "default" do
      it "by default uses creator and title" do
        actual = helper.link_to_work(saved)

        expect(actual).to have_tag('a[href^="/works/"]',
          text:  "Kate Bush: Hounds of Love",
          count: 1
        )
      end

      it "includes subtitle when available" do
        actual = helper.link_to_work(subtitled)

        expect(actual).to have_tag('a[href^="/works/"]',
          text:  "Junior Boys: Like a Child: C2 Remix",
          count: 1
        )
      end
    end

    context "full: false" do
      it "uses just title" do
        actual = helper.link_to_work(saved, full: false)

        expect(actual).to have_tag('a[href^="/works/"]',
          text:  "Hounds of Love",
          count: 1
        )
      end

      it "uses subtitle when available" do
        actual = helper.link_to_work(subtitled, full: false)

        expect(actual).to have_tag('a[href^="/works/"]',
          text:  "Like a Child: C2 Remix",
          count: 1
        )
      end
    end

    context "admin: true" do
      it "optionally links to admin" do
        actual = helper.link_to_work(saved, admin: true)

        expect(actual).to have_tag('a[href^="/admin/works/"]',
          text:  "Kate Bush: Hounds of Love",
          count: 1
        )
      end
    end
  end
end
