require 'rails_helper'

RSpec.describe WorksHelper, type: :helper do
  let(:unsaved) {  build(:minimal_work) }

  describe "#link_to_work" do
    specify{ expect(helper.link_to_work(unsaved)).to eq(nil) }

    it "generates link to title" do
      instance = create(:kate_bush_hounds_of_love)
      actual   = helper.link_to_work(instance)

      expect(actual).to have_tag('a[href^="/works/"]',
        text:  "Hounds of Love",
        count: 1
      )
    end
  end

  describe "#links_to_creators_for_work" do
    specify{ expect(helper.links_to_creators_for_work(unsaved)).to eq(nil) }

    it "generates 1 link for single-creator work" do
      instance = create(:kate_bush_hounds_of_love)
      actual   = helper.links_to_creators_for_work(instance)

      expect(actual).to have_tag('a', count: 1)

      expect(actual).to have_tag('a[href^="/creators/"]',
        text:  "Kate Bush",
        count: 1
      )
    end

    it "generates multiple links for multi-creator work" do
      instance = create(:green_velvet_and_carl_craig_unity)
      actual   = helper.links_to_creators_for_work(instance)

      expect(actual).to have_tag('a', count: 2)

      expect(actual).to match("> & <")

      expect(actual).to have_tag('a[href^="/creators/"]',
        text:  "Green Velvet",
        count: 1
      )

      expect(actual).to have_tag('a[href^="/creators/"]',
        text:  "Carl Craig",
        count: 1
      )
    end

    it "allows separator to be overridden" do
      instance = create(:green_velvet_and_carl_craig_unity)
      actual   = helper.links_to_creators_for_work(instance, separator: "<br>")

      expect(actual).to match("><br><")
    end
  end
end