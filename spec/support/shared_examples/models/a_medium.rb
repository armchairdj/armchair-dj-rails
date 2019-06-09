# frozen_string_literal: true

require "rails_helper"

RSpec.shared_examples "a_medium" do
  describe ":AspectsAssociation" do
    describe "#available_aspects" do
      subject { described_class.new.available_aspects }

      it { is_expected.to be_a_kind_of(Array) }

      described_class.new.available_aspects.each do |key|
        describe "available key #{key}" do
          subject { Aspect.keys.keys }

          it { is_expected.to include(key.to_s) }
        end
      end
    end

    describe "validates #only_available_aspects" do
      subject { build_minimal_instance }

      let!(:all_keys) { Aspect.keys.keys.map(&:to_sym) }
      let!(:avail_keys) { subject.available_aspects }
      let!(:good_key) { avail_keys.first }
      let!(:bad_key) { (all_keys - avail_keys).first }
      let!(:good_aspect) { create(:minimal_aspect, key: good_key) }
      let!(:bad_aspect) { create(:minimal_aspect, key:  bad_key) }

      context "when valid" do
        before do
          subject.aspect_ids = [good_aspect.id]
          subject.valid?
        end

        specify { expect(subject).to be_valid }
      end

      context "when invalid" do
        before { subject.aspect_ids = [bad_aspect.id] }

        it "has the right error" do
          expect(subject).to_not be_valid

          expect(subject).to have_error(:aspects, :invalid)
        end
      end
    end
  end

  describe ":RoleAssociation" do
    let!(:instance) { build_minimal_instance }
    let!(:other_media) { Work.valid_media.reject { |x| x == instance.medium } }
    let!(:good_role_z) { create(:minimal_role, medium: instance.medium, name: "Z") }
    let!(:good_role_a) { create(:minimal_role, medium: instance.medium, name: "A") }
    let!(:bad_role) { create(:minimal_role, medium: other_media.sample) }

    describe "#available_roles" do
      subject { instance.available_roles.map(&:name) }

      it { is_expected.to eq(["A", "Z"]) }
    end

    describe "#available_role_ids" do
      subject { instance.available_role_ids }

      it { is_expected.to eq([good_role_a.id, good_role_z.id]) }
    end
  end

  describe ":SlugAttribute" do
    describe "#sluggable_parts" do
      subject(:sluggable_parts) { instance.sluggable_parts }

      let(:instance) do
        create_minimal_instance(title: "Don't Give Up", subtitle: "Single Edit", maker_names: ["Kate Bush", "Peter Gabriel"])
      end

      it { is_expected.to eq([instance.display_medium.pluralize, "Kate Bush & Peter Gabriel", "Don't Give Up", "Single Edit"]) }
    end
  end
end
