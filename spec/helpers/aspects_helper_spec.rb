# frozen_string_literal: true

require "rails_helper"

RSpec.describe AspectsHelper do
  describe "#link_to_aspect" do
    subject { helper.link_to_aspect(aspect, opts) }

    let(:opts) { {} }

    describe "default" do
      let(:aspect) { create(:minimal_aspect, name: "Aspect") }

      it { is_expected.to have_tag("a[href='/admin/aspects/#{aspect.to_param}']", text: "Aspect", count: 1) }

      describe "with options" do
        let(:opts) { { class: "foo", id: "bar" } }

        it { is_expected.to have_tag("a.foo#bar", count: 1) }
      end
    end
  end
end
