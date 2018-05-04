# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorsHelper, type: :helper do
  let(:unsaved) { build(:minimal_creator) }
  let(  :saved) { create(:creator, name: "Kate Bush") }

  describe "#link_to_creator" do
    specify { expect(helper.link_to_creator(unsaved)).to eq(nil) }

    it "links to site by default" do
      actual = helper.link_to_creator(saved)

      expect(actual).to have_tag('a[href^="/creators/"]',
        text:  "Kate Bush",
        count: 1
      )
    end

    it "links to admin" do
      actual = helper.link_to_creator(saved, admin: true)

      expect(actual).to have_tag('a[href^="/admin/creators/"]',
        text:  "Kate Bush",
        count: 1
      )
    end
  end
end
