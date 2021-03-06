# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorsHelper do
  describe "#link_to_creator" do
    let(:instance) { create(:minimal_creator, name: "Kate Bush") }

    describe "default" do
      subject { helper.link_to_creator(instance) }

      it "has the correct markup" do
        is_expected.to have_tag(
          "a[href='/admin/creators/#{instance.to_param}']",
          text:  "Kate Bush",
          count: 1
        )
      end
    end
  end
end
