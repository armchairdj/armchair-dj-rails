# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaHelper, type: :helper do
  let(:unsaved) { build(:minimal_medium) }
  let(  :saved) { create(:medium, name: "Movie") }

  describe "#link_to_medium" do
    specify { expect(helper.link_to_medium(unsaved)).to eq(nil) }

    it "links to site by default" do
      actual = helper.link_to_medium(saved)

      expect(actual).to have_tag('a[href^="/media/"]',
        text:  "Movie",
        count: 1
      )
    end

    it "links to admin" do
      actual = helper.link_to_medium(saved, admin: true)

      expect(actual).to have_tag('a[href^="/admin/media/"]',
        text:  "Movie",
        count: 1
      )
    end
  end
end
