# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksHelper do
  describe "#link_to_work" do
    let(:instance) { create(:minimal_book, title: "Vacuum Flowers", credits_attributes: {
      "0" => { creator_id: create(:minimal_creator, name: "Michael Swanwick").id }
    }) }

    describe "default" do
      subject { helper.link_to_work(instance) }

      it { is_expected.to have_tag("a[href='/admin/works/#{instance.to_param}']",
        text:  "Michael Swanwick: Vacuum Flowers",
        count: 1
      ) }
    end

    describe "full: false" do
      subject { helper.link_to_work(instance, full: false) }

      it { is_expected.to have_tag("a[href='/admin/works/#{instance.to_param}']",
        text:  "Vacuum Flowers",
        count: 1
      ) }
    end
  end
end
