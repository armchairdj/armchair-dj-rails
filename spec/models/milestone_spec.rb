require "rails_helper"

RSpec.describe Milestone, type: :model do
  context "constants" do
    # Nothing so far.
  end

  context "concerns" do
    it_behaves_like "an_application_record"
  end

  context "class" do
    # Nothing so far.
  end

  context "scope-related" do
    context "basics" do
      let(:remastered) { create(:minimal_milestone, action: :remastered, year: 2005) }
      let(  :released) { create(:minimal_milestone, action: :released,   year: 1977) }
      let(  :reissued) { create(:minimal_milestone, action: :reissued,   year: 2017) }
      let(       :ids) { [remastered, released, reissued].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:work) }
        it { is_expected.to match_array(collection.to_a) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin.where(id: ids) }

        it { is_expected.to eager_load(:work) }
        it { is_expected.to match_array(collection.to_a) }
      end

      describe "self#for_site" do
        subject { collection.for_site.where(id: ids) }

        it { is_expected.to eager_load(:work) }
        it { is_expected.to eq([released, remastered, reissued]) }
      end
    end
  end

  context "associations" do
    it { is_expected.to belong_to(:work) }
  end

  context "attributes" do
    context "enums" do
      it { is_expected.to define_enum_for(:action) }

      it_behaves_like "an_enumable_model", [:action]
    end
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_yearness_of(:year) }

    it { is_expected.to validate_presence_of(:action) }

    context "conditional" do
      # Nothing so far.
    end

    context "custom" do
      # Nothing so far.
    end
  end

  context "hooks" do
    # Nothing so far.

    context "callbacks" do
      # Nothing so far.
    end
  end

  context "instance" do
    # Nothing so far.

    describe "private" do
      # Nothing so far.
    end
  end
end
