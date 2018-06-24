# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagsHelper, type: :helper do
  describe "#link_to_tag" do
    let(:instance) { create(:minimal_tag, name: "Tag") }

    context "default" do
      subject { helper.link_to_tag(instance, admin: true) }

      it { is_expected.to have_tag("a[href='/admin/tags/#{instance.to_param}']",
        text:  "Tag",
        count: 1
      ) }
    end
  end
end
