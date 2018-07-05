# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_medium" do
  describe "class" do
  end

  describe "instance" do
    describe "#available_facets" do
      subject { described_class.new.available_facets }

      it { is_expected.to be_a_kind_of(Array) }

      described_class.new.available_facets.each do |facet|
        describe "available facet #{facet}" do
          subject { Aspect.facets.keys }

          it { is_expected.to include(facet.to_s) }
        end
      end
    end

    describe "role methods" do
      let!(   :instance) { create_minimal_instance }
      let!(:other_media) { Work.valid_media.reject{ |x| x == instance.medium } }
      let!(:good_role_1) { create(:minimal_role, medium: instance.medium, name: "X") }
      let!(:good_role_2) { create(:minimal_role, medium: instance.medium, name: "M") }
      let!(   :bad_role) { create(:minimal_role, medium: other_media.sample) }

      describe "#available_roles" do
        subject { instance.available_roles }

        it { is_expected.to eq([good_role_2, good_role_1]) }
      end

      describe "#available_role_ids" do
        subject { instance.available_role_ids }

        it { is_expected.to eq([good_role_2.id, good_role_1.id]) }
      end
    end
  end
end
