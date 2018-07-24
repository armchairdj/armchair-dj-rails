# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_medium" do
  describe "class" do
    # Nothing so far.
  end

  describe "validation" do
    describe "custom" do
      describe "#only_available_facets" do
        subject { build_minimal_instance }

        let!(:all_facets  ) { Aspect.facets.keys.map(&:to_sym) }
        let!(:avail_facets) { subject.available_facets }
        let!(:good_facet  ) { avail_facets.first }
        let!(:bad_facet   ) { (all_facets - avail_facets).first }
        let!(:good_aspect ) { create(:minimal_aspect, facet: good_facet) }
        let!(:bad_aspect  ) { create(:minimal_aspect, facet:  bad_facet) }

        context "valid" do
          before(:each) { subject.aspect_ids = [good_aspect.id]; subject.valid? }

          specify { expect(subject).to be_valid }
        end

        context "invalid" do
          before(:each) { subject.aspect_ids = [bad_aspect.id] }

          it "has the right error" do
            expect(subject).to_not be_valid

            expect(subject).to have_error(:aspects, :invalid)
          end
        end
      end
    end
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
      let!(:instance   ) { build_minimal_instance }
      let!(:other_media) { Work.valid_media.reject{ |x| x == instance.medium } }
      let!(:good_role_z) { create(:minimal_role, medium: instance.medium, name: "Z") }
      let!(:good_role_a) { create(:minimal_role, medium: instance.medium, name: "A") }
      let!(:bad_role   ) { create(:minimal_role, medium: other_media.sample) }

      describe "#available_roles" do
        subject { instance.available_roles.map(&:name) }

        it { is_expected.to eq(["A", "Z"]) }
      end

      describe "#available_role_ids" do
        subject { instance.available_role_ids }

        it { is_expected.to eq([good_role_a.id, good_role_z.id]) }
      end
    end
  end
end
